classdef Arc<handle
	properties(SetAccess=immutable)
		%依次排列弧的一个端点、弧上一点和弧的另一个端点坐标
		KnownPoints(2,3)
	end
	methods
		function obj = Arc(Points)
			%# 语法
			% ```
			% obj=SymbolicMath.Arc(Points);
			% ```
			%# 输入参数
			% Points(1,3)char，弧的起点、弧上一点、弧的终点名称
			arguments
				Points(1,3)
			end
			obj.KnownPoints=SymbolicMath.TensorPolynomial(arrayfun(@string,Points)+["_X";"_Y"]);
		end
	end
end