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
		function obj = FixedVector(Vector,EndPoint)
			%# 语法
			% ```
			% import SymbolicMath.FixedVector
			%
			% obj=FixedVector(Vector);
			% %将已有FixedVector拷贝到新对象
			%
			% obj=FixedVector(ABString);
			% %使用二字符串创建FixedVector
			%
			% obj=FixedVector(StartPoint,EndPoint);
			% %使用指定的起点和终点创建FixedVector
			% ```
			%# 输入参数
			% Vector(1,1)FixedVector，要拷贝到新对象的旧FixedVector
			% ABString(1,2)char，以二字符串的形式指定FixedVector的起点和终点名称。这要求起点和终点都具有单字符名称。
			% StartPoint,EndPoint(1,1)
			% - 如果指定为Point，则将以指定的Point作为起点和终点
			% - 如果指定为string，则将以指定的字符串作为起点和终点的名称
			%# 特别提示
			% 点名称不是点变量名。如果要使用没有名称的点，则不能使用点名称相关的语法构造。
			if isa(Vector,'SymbolicMath.FixedVector')
				obj=Vector;
			else
				if nargin==1
					Vector=char(Vector);
					EndPoint=Vector(2);
					Vector=Vector(1);
				end
				obj.StartPoint=SymbolicMath.Point(Vector);
				obj.EndPoint=SymbolicMath.Point(EndPoint);
			end
		end
		function SL=get.SquareLength(obj)
			SL=(obj.StartPoint.Coordinate-obj.EndPoint.Coordinate);
			SL=SL*SL.';
		end
		function L=get.Length(obj)
			L=sqrt(obj.SquareLength);
		end
		function ND=get.NumDimensions(obj)
			ND=obj.StartPoint.NumDimensions;
		end
	end
end