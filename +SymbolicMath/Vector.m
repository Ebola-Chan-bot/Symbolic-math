classdef Vector<SymbolicMath.Point
	%向量
	methods
		function obj = Vector(StartPoint,EndPoint)
			obj@SymbolicMath.Point(Coordinate);
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
	methods(Static)
		function obj=New(StartPoint,EndPoint)
			%从起点和终点创建向量
			%# 语法
			% ```
			% obj=SymbolicMath.Vector.New(StartPoint,EndPoint);
			% %依次指定向量的起点和终点
			%
			% obj=SymbolicMath.IsoscelesRightTriangle(ABString);
			% %指定一个二字符串，分别作为起点和终点的点名称
			% ```
			%# 示例
			% ```
			% %以下两种构造方法完全等价，都能构造向量AB：
			% obj=SymbolicMath.IsoscelesRightTriangle('A','B');
			% obj=SymbolicMath.IsoscelesRightTriangle('AB');
			% ```
			%# 输入参数
			% StartPoint,EndPoint(1,1)，底角点名称string或Point对象
			% ABString(1,2)char，指定两个字符，分别作为起点和终点的点名称
			%# 返回值
			% obj(1,1)Vector，向量
			if nargin==1
				AB=char(StartPoint);
				StartPoint=AB(1);
				EndPoint=AB(2);
			end
			[~,StartPoint,EndPoint]=PointDimensionCheck(StartPoint,EndPoint);
			obj=EndPoint-StartPoint;
		end
	end
end