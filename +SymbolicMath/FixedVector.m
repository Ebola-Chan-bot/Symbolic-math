classdef FixedVector
	%具有固定位置的向量
	properties
		StartPoint
		EndPoint
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
			% ABString(1,2)char，以二字符串的形式指定FixedVector的起点和终点名称
			% StartPoint,EndPoint(1,1)
			% - 如果指定为Point，则将以指定的Point作为起点和终点
			% - 如果指定为string，则将以指定的字符串作为起点和终点的名称
			if isa(Vector,'SymbolicMath.Vector')
				obj=Vector;
			elseif isa(Vector,'sym')||isnumeric(Vector)
				obj=SymbolicMath.FixedVector(Vector);
			else
				if nargin==1
					Vector=char(Vector);
					EndPoint=Vector(2);
					Vector=Vector(1);
				end
				obj=SymbolicMath.Point(Vector)-SymbolicMath.Point(EndPoint);
			end
		end
		function Length=abs(obj)
			%返回此向量的长度

			%不能使用norm，会出现额外的abs
			Length=sqrt(obj.SqAbs);
		end
		function Equation=Perpendicular(A,B)
			%设置此向量与另一个向量垂直，返回对应的条件方程

			%不能使用dot，会出现额外的conj
			Equation=sum(A.Coordinate.*B.Coordinate)==0;
		end
		function SqLength=SqAbs(obj)
			%返回此向量长度的平方，比直接取长度再平方更快
			SqLength=sum(obj.Coordinate.*obj.Coordinate);
		end
	end
end