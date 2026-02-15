classdef Point<handle
	%表示一个点
	properties(SetAccess=immutable)
		Coordinate
	end
	methods(Static)
		function Points=FromCoordinates(Coordinates)
			%通过坐标构造点数组
			%# 语法
			% ```
			% Points=SymbolicMath.Point.FromCoordinates(Coordinates);
			% ```
			%# 输入参数
			% Coordinates(2,:)，点的坐标，第1维XY，第2维不同的点
			%# 返回值
			% Points(1,:)SymbolicMath.Point，点数组
			for P=width(Coordinates):-1:1
				Points(P)=SymbolicMath.Point(Coordinates(:,P));
			end
		end
	end
	methods
		function obj = Point(CN)
			%# 语法
			% ```
			% obj=SymbolicMath.Point(Coordinate);
			% %通过坐标构造一个点
			%
			% obj=SymbolicMath.Point(Name);
			% %通过名称构造一个点
			% ```
			%# 输入参数
			% Name(1,1)char，点的名称
			% MirrorPoint(1,1)SymbolicMath.Point，镜像点
			% SymmetricalIn(1,1)SymbolicMath.StraightLine，对称轴
			% Arc(1,1)SymbolicMath.Arc，弧
			if isa(CN,'char')
				obj.Coordinate=SymbolicMath.TensorPolynomial(CN+["_X";"_Y"]);
			else
				obj.Coordinate=CN;
			end
		end
	end
end