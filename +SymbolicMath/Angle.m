classdef Angle<handle
	%表示一个角
	properties(SetAccess=immutable)
		%依次排列角的一边上一点、顶点和另一边上一点
		KnownPoints(2,3)

		%顶点坐标
		Vertex

		%两条边的向量
		SideVectors

		%角平分线
		Bisector
	end
	methods
		function obj = Angle(KnownPoints)
			%# 语法
			% ```
			% obj=SymbolicMath.Angle(KnownPoints);
			% ```
			%# 输入参数
			% KnownPoints(1,3)char，用一边上一点、顶点、另一边上一点定义一个角
			obj.KnownPoints=SymbolicMath.TensorPolynomial(arrayfun(@string,KnownPoints)+["_X";"_Y"]);
			obj.Vertex=obj.KnownPoints(:,2);
			obj.SideVectors=obj.KnownPoints(:,[1,3])-obj.Vertex;
			obj.Bisector=SymbolicMath.StraightLine(obj);
		end
	end
end