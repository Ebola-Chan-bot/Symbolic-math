classdef Point<SymbolicMath.IDimensional
	%点
	properties(SetAccess=immutable)
		%坐标向量
		Coordinate(1,:)
	end
	properties(Dependent,SetAccess=immutable)
		%点的维度，即坐标向量的长度
		NumDimensions
	end
	methods
		function obj = Point(LineA,LineB,NumDimensions)
			%# 语法
			% ```
			% import SymbolicMath.Point
			%
			% obj=Point(Name);
			% %使用指定名称构造二维Point
			%
			% obj=Point(LineA,LineB);
			% %获取两条线的交点，点的维数与线相同
			%
			% obj=Point(___,NumDimensions);
			% %与上述任意语法组合使用，额外指定点的维数
			%
			% obj=Point(Coordinate);
			% %使用指定坐标构造新Point
			%
			% obj=Point(OldPoint);
			% %使用已有Point构造新Point
			% ```
			%# 输入参数
			% OldPoint(1,1)Point，将构造一个与输入完全相同的新Point
			% Name(1,1)string，点的名称
			% NumDimensions(1,1)=2，点的维数
			% Coordinate(1,:)，sym或数值类型，点的各维坐标
			% LineA,LineB，点所在的两条线，维数必须相同且等于NumDimensions（如果指定了的话）
			% - 可以是(1,1)StraightLine
			% - 如果是(1,1)FixedVector，将自动转换为StraightLine，因此交点可能在FixedVector两点范围之外。
			% - 如果是(1,2)char，将创建指定的两个字符确定的两点所在的直线
			%# 特别提示
			% 点的名称与工作区中的点变量名无关。所有具有相同名称的点视为同一点，即使它们的变量名不同。点可以没有名称，没有名称的点只能通过工作取变量访问。
			switch nargin
				case 1
					if isa(LineA,'SymbolicMath.Point')
						obj=LineA;
					elseif ischar(LineA)||isstring(LineA)
						obj.Coordinate=sym(LineA,[1,NumDimensions]);
					else
						obj.Coordinate=LineA;
					end
				case 2
					if isscalar(LineB)&&isnumeric(LineB)
						obj.Coordinate=sym(LineA,[1,LineB]);
					else
						obj.Coordinate=GetIntersection(LineA,LineB);
					end
				case 3
					obj.Coordinate=GetIntersection(LineA,LineB,NumDimensions);
			end
		end
		function ND=get.NumDimensions(obj)
			ND=numel(obj.Coordinate);
		end
	end
end
function Coordinate=GetIntersection(LineA,LineB,varargin)
LineA=SymbolicMath.StraightLine(LineA,varargin{:});
LineB=SymbolicMath.StraightLine(LineB,varargin{:});
NumDimensions=LineA.NumDimensions;
Coordinate=[LineA.Position,LineB.Position]/[eye(NumDimensions),eye(NumDimensions);LineA.Direction,zeros(1,3);zeros(1,3),LineB.Direction];
Coordinate=Coordinate(1:NumDimensions);
end