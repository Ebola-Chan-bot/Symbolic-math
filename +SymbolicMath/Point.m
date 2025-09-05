classdef Point
	properties
		%XY坐标
		Coordinate(2,1)
	end

	methods
		function obj = Point(Coordinate)
			if isscalar(Coordinate)
				obj.Coordinate=sym(Coordinate+["1";"2"],'real');
			else
				obj.Coordinate=Coordinate;
			end
		end
		function Vector=minus(objA,objB)
			Vector=objA.Coordinate-objB.Coordinate;
		end
		function disp(obj)
			disp(obj.Coordinate);
		end
	end
end