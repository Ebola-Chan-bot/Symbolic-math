classdef StraightLine<SymbolicMath.IDimensional
	%直线，由两点确定
	properties(SetAccess=immutable)
		PointA
		PointB
	end
	properties(SetAccess=immutable,Dependent)
		NumDimensions
	end
	methods
		function obj=StraightLine(PointA,PointB,NumDimensions)
			%使用静态方法New以支持拷贝构造
			%# 语法
			% ```
			% import SymbolicMath.StraightLine
			%
			% obj=StraightLine(ABString);
			% %使用二字符串创建二维直线
			%
			% obj=StraightLine(PointA,PointB);
			% %使用指定的两点创建直线
			%
			% obj=StraightLine(___,NumDimensions);
			% %与上述任意语法组合使用，额外指定直线的维数
			%
			% obj=StraightLine(StraightLine);
			% %从已有直线拷贝
			%
			% obj=StraightLine(FixedVector);
			% %从固定向量创建直线
			%
			% obj=StraightLine(Equations);
			% %指定直线线性方程组。各维变量将通过symvar(Equations)取得。
			%
			% obj=StraightLine(Equations,DimensionVars);
			% %指定直线线性方程组和各维度变量
			% ```
			%# 输入参数
			% StraightLine(1,1)StraightLine，用于拷贝的直线
			% FixedVector(1,1)FixedVector，用于创建直线的固定向量
			% ABString(1,2)char，以二字符串的形式指定直线上的两点名称。这要求两点都具有单字符名称。
			% PointA,PointB，输入两点以确定一条直线。
			% - 如果指定为(1,1)Point，则将以指定的Point作为直线上的点
			% - 如果指定为(1,1)string，则将以指定的字符串作为点的名称
			% - 如果指定为(1,:)sym或数值类型，将视为直线上该点的坐标
			% NumDimensions(1,1)，直线的维数。如果不指定此参数，将根据输入的点确定维数。如果输入点均为名称形式，直线将是二维的。
			% Equations(:,1)sym，直线的线性方程组，应该比直线的维数少一个
			% DimensionVars(:,1)sym，方程组中代表各个维度的变量，应该和直线的维数一样多
			%# 特别提示
			% 点名称不是点变量名。如果要使用没有名称的点，则不能使用点名称相关的语法构造。
			%See also symvar SymbolicMath.FixedVector SymbolicMath.Point
			switch nargin
				case 1
					if isa(PointA,'SymbolicMath.StraightLine')
						obj=PointA;
					elseif isa(PointA,'SymbolicMath.FixedVector')
						obj.PointA=PointA.StartPoint;
						obj.PointB=PointA.EndPoint;
					elseif ischar(PointA)||isstring(PointA)
						PointA=char(PointA);
						[obj.PointA,obj.PointB]=GetPointCoordinate(PointA(1),PointA(2));
					else
						[obj.PointA,obj.PointB]=EquationsToPoints(Equations);
					end
			end
			if isa(Position,'SymbolicMath.StraightLine')
				obj=Position;
			else
				if nargin==1
					if isa(Position,'SymbolicMath.FixedVector')
						Direction=Position.EndPoint;
						Position=Position.StartPoint;
					elseif isa(Position,'sym')
						Direction=symvar(Position);
					else
						Position=char(Position);
						Direction=Position(2);
						Position=Position(1);
					end
				end
				if ~((isa(Position,'sym')||isnumeric(Position))&&(isa(Direction,'sym')||isnumeric(Direction)))
					[Position,Direction]=GetPointCoordinate(Position,Direction);
				end
				NumDimensions=numel(Direction);
				if numel(Position)<NumDimensions
					Direction=Direction(:);
					AllTerms=[Direction;1];
					Coefficients=sym(zeros(NumDimensions,NumDimensions+1));
					for E=1:NumDimensions-1
						[Coeffs,Terms]=coeffs(lhs(Position(E))-rhs(Position(E)),Direction);
						[~,Index]=ismember(Terms,AllTerms);
						Coefficients(E,Index)=Coeffs;
					end
					WarnState=warning('query','symbolic:mldivide:RankDeficientSystem').state;
					warning('off','symbolic:mldivide:RankDeficientSystem');
					Position=Coefficients(:,1:NumDimensions)\-Coefficients(:,NumDimensions+1);
					warning(WarnState,'symbolic:mldivide:RankDeficientSystem');
					VolatileDimension=logical(Coefficients(1:end-1,1:end-1)~=0);
					VolatileDimension=find(~any(VolatileDimension(sum(VolatileDimension,2)==1,:),1),1);
					Coefficients(end,VolatileDimension)=1;
					Coefficients(end,end)=Position(VolatileDimension)+1;
					obj.Direction=(Coefficients(:,1:NumDimensions)\-Coefficients(:,NumDimensions+1)-Position).';
					obj.Position=Position.';
				else
					obj.Position=Position;
					obj.Direction=Direction-Position;
				end
			end
		end
		function ND=get.NumDimensions(obj)
			ND=numel(obj.Direction);
		end
	end
end
function [PointA,PointB]=EquationsToPoints(PointA,varargin)
[PointA,PointB]=equationsToMatrix(PointA,varargin{:});
WarnState=warning('query','symbolic:mldivide:RankDeficientSystem').state;
warning('off','symbolic:mldivide:RankDeficientSystem');
PointA=-Coefficients(end,:)/Coefficients(1:NumDimensions,:);
warning(WarnState,'symbolic:mldivide:RankDeficientSystem');
VolatileDimension=logical(Coefficients(1:NumDimensions,1:end-1)~=0);
VolatileDimension=find(~any(VolatileDimension(sum(VolatileDimension,1)==1,:),2),1);
Coefficients(VolatileDimension,end)=1;
Coefficients(end,end)=PointA(VolatileDimension)+1;
PointB=-Coefficients(end,:)/Coefficients(1:NumDimensions,:);
end