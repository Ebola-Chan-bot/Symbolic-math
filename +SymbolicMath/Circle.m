classdef Circle
	properties
		%圆心坐标
		Center(2,1)
		%半径
		Radius(1,1)
	end
	methods
		function obj=Circle(Center,Radius)
			obj.Center=Center;
			obj.Radius=Radius^2;
		end
	end
end