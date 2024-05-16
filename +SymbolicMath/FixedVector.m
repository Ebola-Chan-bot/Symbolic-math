classdef FixedVector<SymbolicMath.ILength
	%具有固定位置的向量，又称有向线段
	properties(SetAccess=immutable)
		StartPoint
		EndPoint
	end
	properties(Dependent,SetAccess=immutable)
		Length
		SquareLength
		NumDimensions
	end
	methods
		function obj = FixedVector(StartPoint,EndPoint,NumDimensions)
			%# 语法
			% ```
			% import SymbolicMath.FixedVector
			%
			% obj=FixedVector(ABString);
			% %使用二字符串创建二维FixedVector
			%
			% obj=FixedVector(StartPoint,EndPoint);
			% %使用指定的起点和终点创建FixedVector
			%
			% obj=FixedVector(___,NumDimensions);
			% %与上述任意语法组合使用，额外指定向量的维数
			%
			% obj=FixedVector(Vector);
			% %将已有FixedVector拷贝到新对象
			% ```
			%# 输入参数
			% Vector(1,1)FixedVector，要拷贝到新对象的旧FixedVector
			% ABString(1,2)char，以二字符串的形式指定FixedVector的起点和终点名称。这要求起点和终点都具有单字符名称。
			% NumDimensions(1,1)，向量的维数。如果不指定此参数，将根据输入的点确定维数。如果输入点均为名称形式，向量将是二维的。
			% StartPoint,EndPoint，向量的起点和终点，维数必须相同且等于NumDimensions（如果指定了的话）
			% - 如果指定为(1,1)Point，则将以指定的Point作为起点或终点
			% - 如果指定为(1,1)string，则将以指定的字符串作为起点或终点的名称
			% - 如果指定为sym或数值类型，则将以指定的坐标作为起点或终点
			%# 特别提示
			% 点名称不是点变量名。如果要使用没有名称的点，则不能使用点名称相关的语法构造。
			switch nargin
				case 1
					if isa(StartPoint,'SymbolicMath.FixedVector')
						obj=StartPoint;
					else
						StartPoint=char(StartPoint);
						[obj.StartPoint,obj.EndPoint]=GetPointCoordinate(StartPoint(1),StartPoint(2));
					end
				case 2
					if isscalar(EndPoint)&&isnumeric(EndPoint)
						StartPoint=char(StartPoint);
						[obj.StartPoint,obj.EndPoint]=GetPointCoordinate(EndPoint,StartPoint(1),StartPoint(2));
					else
						[obj.StartPoint,obj.EndPoint]=GetPointCoordinate(StartPoint,EndPoint);
					end
				case 3
					[obj.StartPoint,obj.EndPoint]=GetPointCoordinate(NumDimensions,StartPoint,EndPoint);
			end
		end
		function SL=get.SquareLength(obj)
			SL=(obj.StartPoint-obj.EndPoint);
			SL=SL*SL.';
		end
		function L=get.Length(obj)
			L=sqrt(obj.SquareLength);
		end
		function ND=get.NumDimensions(obj)
			ND=numel(obj.StartPoint);
		end
	end
end