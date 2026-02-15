classdef TensorPolynomial<SymbolicMath.Vectorizable
	%张量表示的多项式
	properties(SetAccess=protected)
		TermCoefficients
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
			obj.TermCoefficients=table;
			if isempty(vars)
				obj.TermCoefficients.Coefficient=Polynomial;
				return;
			end
			[obj.TermCoefficients.Coefficient, monomials] = coeffs(Polynomial, vars); % coeffVec(k) * monomials(k)
			exps=uint8(MATLAB.DataTypes.ArrayFun(@(M,V)SE.feval('degree',M,V),monomials,vars));
			obj.TermCoefficients.Term=array2table(exps,VariableNames=string(vars));
		end
	end
	methods(Static)
		function ConclusionRemainders = Prove(Conditions,ConclusionRemainders)
			for Cc=1:numel(ConclusionRemainders)
				AnyConditionApplied=true;
				ConditionsLeft=Conditions;
				Remainder=ConclusionRemainders(Cc);
				while AnyConditionApplied&&~isempty(Remainder.TermCoefficients.Term.Properties.VariableNames)
					AnyConditionApplied=false;
					for Cd=1:numel(ConditionsLeft)
						[Remainder,ConditionApplied] = Eliminate(Remainder,ConditionsLeft(Cd));
						if ConditionApplied
							AnyConditionApplied=true;
							ConditionsLeft(Cd) = [];
							break;
						end
					end
				end
				ConclusionRemainders(Cc)=Remainder;
			end
		end
	end
	methods(Access=protected)
		function S=sym__(obj)
			S=obj.sym_;
		end
		function objA=plus_(objA,objB)
			[objA.TermCoefficients.Term,objB.TermCoefficients.Term]=UnionTerms(objA,objB);
			objA.TermCoefficients=TcPlus(objA.TermCoefficients,objB.TermCoefficients);
			objA=objA.simplify_;
		end
		function objA=minus_(objA,objB)
			[objA.TermCoefficients.Term,objB.TermCoefficients.Term]=UnionTerms(objA,objB);
			objB.TermCoefficients.Coefficient=-objB.TermCoefficients.Coefficient;
			objA.TermCoefficients=TcPlus(objA.TermCoefficients,objB.TermCoefficients);
			objA=objA.simplify_;
		end
		function objA=times_(objA,objB)
			[TermsA,TermsB]=UnionTerms(objA,objB);
			if isempty(TermsA)||isempty(TermsB)
				objA.TermCoefficients(1:end,:)=[];
				return;
			end
			VariableNames=union(TermsB.Properties.VariableNames,TermsA.Properties.VariableNames);
			objA.TermCoefficients.Term=TermsA;
			objB.TermCoefficients.Term=TermsB;
			objA.TermCoefficients=TcConvN(objA.TermCoefficients,objB.TermCoefficients,VariableNames);
			objA=objA.simplify_;
		end
		function TF=eq_(objA,objB)
			TermsA=objA.simplify_.TermCoefficients;
			TermsB=objB.simplify_.TermCoefficients;
			if any(TermsA.Properties.VariableNames=="Term")
				if any(TermsB.Properties.VariableNames=="Term")
					[~,SortIndexA]=sortrows(TermsA.Term);
					[~,SortIndexB]=sortrows(TermsB.Term);
					TF=isequaln(TermsA(SortIndexA,:),TermsB(SortIndexB,:));
				else
					TF=isempty(TermsA);
				end
			else
				TF=all(TermsB.Properties.VariableNames~="Term");
			end
		end
		function S=sym_(obj)
			if isempty(obj.TermCoefficients)
				S=sym(0);
			else
				S=prod(sym(obj.TermCoefficients.Term.Properties.VariableNames).^obj.TermCoefficients.Term{:,:},2).'*obj.TermCoefficients.Coefficient;
			end
		end
		function obj=simplify_(obj)
			obj.TermCoefficients=TcSimplify(obj.TermCoefficients);
			obj.TermCoefficients.Term(:,~any(obj.TermCoefficients.Term{:,:},1))=[];
		end
	end
	methods
		function obj = TensorPolynomial(SymbolicValues)
			if nargin
				if isa(SymbolicValues,'SymbolicMath.TensorPolynomial')
					obj=SymbolicValues;
				else
					obj = arrayfun(@SymbolicMath.TensorPolynomial.TensorPolynomial_,SymbolicValues);
				end
			end
		end
		function obj=plus(objA,objB)
			arguments
				objA SymbolicMath.TensorPolynomial
				objB SymbolicMath.TensorPolynomial
			end
			obj=MATLAB.DataTypes.ArrayFun(@plus_,objA,objB);
		end
		function obj=minus(objA,objB)
			arguments
				objA SymbolicMath.TensorPolynomial
				objB SymbolicMath.TensorPolynomial
			end
			obj=MATLAB.DataTypes.ArrayFun(@minus_,objA,objB);
		end
		function obj=times(objA,objB)
			arguments
				objA SymbolicMath.TensorPolynomial
				objB SymbolicMath.TensorPolynomial
			end
			obj=MATLAB.DataTypes.ArrayFun(@times_,objA,objB);
		end
		function TF=eq(objA,objB)
			arguments
				objA SymbolicMath.TensorPolynomial
				objB SymbolicMath.TensorPolynomial
			end
			TF=MATLAB.DataTypes.ArrayFun(@eq_,objA,objB);
		end
		function obj=conj(obj)
			%不做任何事
		end
		function obj=sqrt(obj)
			for O=1:numel(obj)
				obj(O).Tensor=ifftn(sqrt(fftn(obj(O).Tensor)));
			end
		end
	end
end
function [TermsA,TermsB]=UnionTerms(objA,objB)
TermsA=objA.TermCoefficients.Term;
TermsB=objB.TermCoefficients.Term;
TermsA{:,setdiff(TermsB.Properties.VariableNames,TermsA.Properties.VariableNames)}=0;
TermsB{:,setdiff(TermsA.Properties.VariableNames,TermsB.Properties.VariableNames)}=0;
end
function NewTermCoefficients=TcPlus(TCA,TCB)
NewTermCoefficients=table;
NewTermCoefficients.Term=union(TCA.Term,TCB.Term);
[~,Index]=ismember(TCA.Term,NewTermCoefficients.Term);
NewTermCoefficients.Coefficient(Index)=TCA.Coefficient;
[~,Index]=ismember(TCB.Term,NewTermCoefficients.Term);
NewTermCoefficients.Coefficient(Index)=NewTermCoefficients.Coefficient(Index)+TCB.Coefficient;
end
function NewTerms=TcConvN(TCA,TCB,VariableNames)
arguments
	TCA
	TCB
	VariableNames=TCA.Term.Properties.VariableNames
end
NewTerms=permute(TCA.Term{:,VariableNames},[2,1,3])+permute(TCB.Term{:,VariableNames},[2,3,1]);
NewTerms=table(array2table(NewTerms(:,:).',VariableNames=VariableNames),'VariableNames',"Term");
NewCoefficients=TCA.Coefficient.*TCB.Coefficient.';
NewTerms.Coefficient=NewCoefficients(:);
end
function NewTerms=TcSimplify(TermCoefficients)
%此方法只合并同类项，不删除全零次变量
if all(TermCoefficients.Properties.VariableNames~="Term")
	return;
end
NewTerms=table;
[NewTerms.Term,~,Group]= unique(TermCoefficients.Term);
if isempty(Group)
	TermCoefficients.Term=table;
	return;
end
NewTerms.Coefficient=splitapply(@sum,TermCoefficients.Coefficient,Group);
NewTerms(abs(NewTerms.Coefficient)<eps,:)=[];
end
function [ConclusionRemainder,ConditionApplied] = Eliminate(ConclusionRemainder,Condition)
ToEliminate=find(ismember(ConclusionRemainder.TermCoefficients.Term.Properties.VariableNames,Condition.TermCoefficients.Term.Properties.VariableNames),1,'last');
if isempty(ToEliminate)
	ConditionApplied=false;
	return;
end
ToEliminate=ConclusionRemainder.TermCoefficients.Term.Properties.VariableNames(ToEliminate);
[ConclusionRemainder.TermCoefficients.Term,Condition.TermCoefficients.Term]=UnionTerms(ConclusionRemainder,Condition);
TCA=ConclusionRemainder.TermCoefficients;
TCB=Condition.TermCoefficients;
TCB.Term=TCB.Term(:,TCA.Term.Properties.VariableNames);
ToEliminate=find(TCA.Term.Properties.VariableNames==string(ToEliminate),1);
while true
	SizeA=max(TCA.Term{:,ToEliminate});
	SizeB=max(TCB.Term{:,ToEliminate});
	if SizeA<SizeB
		[TCA,TCB]=deal(TCB,TCA);
		[SizeA,SizeB]=deal(SizeB,SizeA);
	end
	Multiplier=TCB(TCB.Term{:,ToEliminate}==SizeB,:);
	Multiplier.Term{:,ToEliminate}=0;
	NewTCA=TcConvN(TCA,Multiplier);
	Multiplier=TCA(TCA.Term{:,ToEliminate}==SizeA,:);
	Multiplier.Term{:,ToEliminate}=0;
	NewTCB=TcConvN(TCB,Multiplier);
	NewTCB.Term{:,ToEliminate}=NewTCB.Term{:,ToEliminate}+SizeA-SizeB;
	NewTCB.Coefficient=-NewTCB.Coefficient;
	TCA=TcSimplify(TcPlus(NewTCA,NewTCB));
	TCA.Term{:,:}=TCA.Term{:,:}-min(TCA.Term{:,:},[],1);
	if isempty(TCA.Term)
		ConclusionRemainder=SymbolicMath.TensorPolynomial(0);
		ConditionApplied=true;
		break;
	end
	%这里TCA和TCB变量顺序应该是一样的
	Logical=any(TCA.Term{:,:},1)|any(TCB.Term{:,:},1);
	TCA.Term=TCA.Term(:,Logical);
	if~Logical(ToEliminate)
		ConclusionRemainder.TermCoefficients=TCA;
		ConditionApplied=true;
		break;
	end
	TCB.Term=TCB.Term(:,Logical);
end
end