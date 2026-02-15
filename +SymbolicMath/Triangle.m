classdef Triangle<handle
	%表示一个三角形
	properties(SetAccess=immutable)
		%第1维XY坐标，第2维三个顶点
		Vertices(2,3)
		
		%三角形的外接圆
		Circumscribe
	end
	methods
		function obj = Triangle(Vertices)
			%# 语法
			% ```
			% obj=SymbolicMath.Triangle(Vertices);
			% ```
			%# 输入参数
			% Vertices(1,3)char，三个顶点的名称
			obj.Vertices=SymbolicMath.TensorPolynomial(arrayfun(@string,Vertices)+["_X";"_Y"]);
			obj.Circumscribe=SymbolicMath.Circle(obj.Vertices);
		end
		function disp(obj)
			disp(obj.Vertices);
		end
	end
end