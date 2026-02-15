classdef Circle<handle
	%表示一个圆
	properties
		%圆上已知的点坐标，至少有3个
		KnownPoints(2,:)
	end
	methods
		function obj=Circle(KnownPoints)
			%# 语法
			% ```
			% obj=SymbolicMath.Circle(KnownPoints);
			% ```
			%# 输入参数
			% KnownPoints(2,3:)，圆上至少3点坐标
			obj.KnownPoints=KnownPoints;
		end
	end
end