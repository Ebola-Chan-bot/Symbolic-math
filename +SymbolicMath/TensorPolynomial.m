classdef TensorPolynomial<SymbolicMath.Vectorizable
	%张量表示的多项式
	properties(SetAccess=protected)
		Tensor double
		VariableNames string
	end
	methods(Static,Access=protected)
		function obj = TensorPolynomial_(Polynomial)
			arguments
				Polynomial sym
			end
			persistent SE
			if isempty(SE)
				SE=symengine;
			end
			Polynomial = expand(Polynomial); % 确保已展开
			vars = symvar(Polynomial);      % 自动按符号名字典顺序 (MATLAB 规则) 获取变量
			obj=SymbolicMath.TensorPolynomial;
			obj.VariableNames = vars;
			if isempty(vars)
				obj.Tensor = sym(Polynomial);
				return;
			end
			[coeffVec, monomials] = coeffs(Polynomial, vars); % coeffVec(k) * monomials(k)
			[monomials,vars]=meshgrid(monomials,vars);
			exps=uint8(arrayfun(@(M,V)SE.feval('degree',M,V),monomials,vars));
			TensorSize=max(exps, [], 2).';
			if isscalar(TensorSize)
				TensorSize(2)=1;
			end
			obj.Tensor = zeros(TensorSize);
			exps=num2cell(exps+1);
			for j = 1:numel(coeffVec)
				obj.Tensor(exps{:,j}) =  coeffVec(j);
			end
		end
	end
	methods(Access=?SymbolicMath.Fractional)
		function S=sym__(obj)
			S=obj.sym_;
		end
		function objA=plus_(objA,objB)
			arguments
				objA
				objB SymbolicMath.TensorPolynomial
			end
			[objA.VariableNames,TensorA,TensorB] = UnionVariables(objA,objB);
			objA.Tensor = TensorA + TensorB;
		end
		function objA=minus_(objA,objB)
			arguments
				objA
				objB SymbolicMath.TensorPolynomial
			end
			[objA.VariableNames,TensorA,TensorB] = UnionVariables(objA,objB);
			objA.Tensor = TensorA - TensorB;
		end
		function objA=times_(objA,objB)
			arguments
				objA
				objB SymbolicMath.TensorPolynomial
			end
			[objA.VariableNames,TensorA,TensorB] = UnionVariables(objA,objB);
			objA.Tensor = convn(TensorA,TensorB);
		end
		function TF=eq_(objA,objB)
			arguments
				objA
				objB SymbolicMath.TensorPolynomial
			end
			[~,TensorA,TensorB] = UnionVariables(objA.simplify_,objB.simplify_);
			TF=isequaln(TensorA,TensorB);
		end
	end
	methods(Access=protected)
		function S=sym_(obj)
			T=obj.Tensor;
			if isempty(T)
				S=sym(0);
				return;
			end
			if isempty(obj.VariableNames)
				S=sym(T);
				return;
			end
			vars = sym(obj.VariableNames);
			sz = size(T);
			S = sym(0);
			nz = find(T~=0);
			if isempty(nz)
				S = sym(0);
				return;
			end
			sub=cell(1,numel(vars));
			for idxLin = nz.'
				[sub{:}] = ind2sub(sz, idxLin);
				% 生成该项
				S=S+ sym(T(idxLin))*prod(vars.^([sub{:}]-1));
			end
		end
		function obj=simplify_(obj)
			NumVariables=numel(obj.VariableNames);
			StripSubs=cell(1,NumVariables);
			Dimensions=1:NumVariables;
			for D=1:NumVariables
				StripSubs{D}=1:find(any(obj.Tensor,setdiff(Dimensions,D)),1,'last');
			end
			obj.Tensor = obj.Tensor(StripSubs{:});
			if isempty(obj.Tensor)
				obj.VariableNames=[];
				obj.Tensor=0;
			else
				NewSize=size(obj.Tensor,Dimensions);
				Logical=NewSize>1;
				obj.VariableNames=obj.VariableNames(Logical);
				NewSize=NewSize(Logical);
				switch numel(NewSize)
					case 0
					case 1
						obj.Tensor=obj.Tensor(:);
					otherwise
						obj.Tensor = reshape(obj.Tensor,NewSize);
				end
			end
		end
	end
	methods
		function obj = TensorPolynomial(SymbolicValues)
			if nargin
				obj = arrayfun(@SymbolicMath.TensorPolynomial.TensorPolynomial_,SymbolicValues);
			end
		end
		function obj=plus(objA,objB)
			if isa(objB,'SymbolicMath.Fractional')
				obj=SymbolicMath.Fractional(objA)+objB;
			else
				obj=MATLAB.DataTypes.ArrayFun(@plus_,objA,objB);
			end
		end
		function obj=minus(objA,objB)
			if isa(objB,'SymbolicMath.Fractional')
				obj=SymbolicMath.Fractional(objA)-objB;
			else
				obj=MATLAB.DataTypes.ArrayFun(@minus_,objA,objB);
			end
		end
		function obj=times(objA,objB)
			if isa(objB,'SymbolicMath.Fractional')
				obj=SymbolicMath.Fractional(objA).*objB;
			else
				obj=MATLAB.DataTypes.ArrayFun(@times_,objA,objB);
			end
		end
		function TF=eq(objA,objB)
			if isa(objB,'SymbolicMath.Fractional')
				TF=SymbolicMath.Fractional(objA)==objB;
			else
				TF=MATLAB.DataTypes.ArrayFun(@eq_,objA,objB);
			end
		end
		function obj=rdivide(objA,objB)
			obj=SymbolicMath.Fractional(objA,objB);
		end
	end
end
function [VariableNames,TensorA,TensorB]=UnionVariables(objA,objB)
arguments
	objA SymbolicMath.TensorPolynomial
	objB SymbolicMath.TensorPolynomial
end
[VariableNames,TensorA,TensorB] = MATLAB.Ops.UnionN(2,objA.VariableNames,objB.VariableNames);
if isempty(VariableNames)
	TensorA=objA.Tensor;
	TensorB=objB.Tensor;
else
	Index=(1:numel(VariableNames)).';
	TensorA=ipermute(objA.Tensor,[TensorA;setdiff(Index,TensorA)]);
	TensorB=ipermute(objB.Tensor,[TensorB;setdiff(Index,TensorB)]);
end
end