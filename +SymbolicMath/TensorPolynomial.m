classdef TensorPolynomial
	%张量表示的多项式
	properties(SetAccess=protected)
		Tensor double
		VariableNames string
	end
	methods
		function obj = TensorPolynomial(Polynomial)
			% 构造: 传入 sym 多项式, 生成按变量指数张量表示
			% 约定: Tensor 的各维顺序对应 VariableNames 中的变量顺序;
			%       每一维索引 k (从 1 开始) 表示该变量的 (k-1) 次幂。
			% 示例: p = x^2 + y^2; VariableNames = ["x","y"];
			%       Tensor(3,1)=1 (x^2), Tensor(1,3)=1 (y^2)。
			arguments
				Polynomial sym
			end
			persistent SE
			if isempty(SE)
				SE=symengine;
			end

			Polynomial = expand(Polynomial); % 确保已展开
			vars = symvar(Polynomial);      % 自动按符号名字典顺序 (MATLAB 规则) 获取变量
			obj.VariableNames = vars;

			% 常数多项式: 无变量
			if isempty(vars)
				% Tensor 就是一个 1x1, 存该常数
				obj.Tensor = sym(Polynomial);
				return;
			end

			% 提取各项 (系数 + 单项式)
			[coeffVec, monomials] = coeffs(Polynomial, vars); % coeffVec(k) * monomials(k)

			% 计算每项对每个变量的指数
			[monomials,vars]=meshgrid(monomials,vars);
			exps=uint8(arrayfun(@(M,V)SE.feval('degree',M,V),monomials,vars));

			% 预分配符号张量 (全部 0)
			TensorSize=max(exps, [], 2).';
			if isscalar(TensorSize)
				TensorSize(2)=1;
			end
			obj.Tensor = zeros(TensorSize);

			% 将每一项放入张量位置: 指数 + 1 作为索引
			exps=num2cell(exps+1);
			for j = 1:numel(coeffVec)
				obj.Tensor(exps{:,j}) =  coeffVec(j);
			end
		end
		function S=sym(obj)
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
		function obj=simplify(obj)
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
				obj.Tensor = reshape(obj.Tensor,NewSize(Logical));
			end
		end
		function objA=plus(objA,objB)
			arguments
				objA
				objB SymbolicMath.TensorPolynomial
			end
			[objA.VariableNames,TensorA,TensorB] = UnionVariables(objA,objB);
			objA.Tensor = TensorA + TensorB;
			objA=objA.simplify;
		end
		function objA=minus(objA,objB)
			arguments
				objA
				objB SymbolicMath.TensorPolynomial
			end
			[objA.VariableNames,TensorA,TensorB] = UnionVariables(objA,objB);
			objA.Tensor = TensorA - TensorB;
			objA=objA.simplify;
		end
		function objA=times(objA,objB)
			arguments
				objA
				objB SymbolicMath.TensorPolynomial
			end
			[objA.VariableNames,TensorA,TensorB] = UnionVariables(objA,objB);
			objA.Tensor = convn(TensorA,TensorB);
			objA=objA.simplify;
		end
	end
end
function [VariableNames,TensorA,TensorB]=UnionVariables(objA,objB)
[VariableNames,TensorA,TensorB] = MATLAB.Ops.UnionN(2,objA.VariableNames,objB.VariableNames);
Index=(1:numel(VariableNames)).';
TensorA=ipermute(objA.Tensor,[TensorA;setdiff(Index,TensorA)]);
TensorB=ipermute(objB.Tensor,[TensorB;setdiff(Index,TensorB)]);
end