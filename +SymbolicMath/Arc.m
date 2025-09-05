classdef Arc
	properties
		%圆心
		Center(2,1)

		%半径
		Radius(1,1)

		%顺时针方向，弧的起点和终点的倾角(-π,π]
		Angles(1,2)
	end
	methods
		function obj = Arc(Center,Radius,Angles)
			
		end
	end
end