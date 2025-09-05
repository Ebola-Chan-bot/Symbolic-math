classdef StraightLine
	properties
		%倾角
		Angle(1,1)
		
		%到原点的有向距离
		%直线上任一点(X,Y)满足X.*sin(Angle)-Y.*cos(Angle)==DirectionalOriginDistance
		DirectionalOriginDistance(1,1)
	end
	methods
		function obj = StraightLine(Angle,DirectionalOriginDistance)
			obj.Angle = Angle;
			obj.DirectionalOriginDistance = DirectionalOriginDistance;
		end
		function S=Symmetry(obj,S)
			%以本直线为对称轴，求图形对象的对称对象
			if ischar(S)
				S=SymbolicMath.Point(S);
			end
			if isa(S,'SymbolicMath.Point')
				sinA = sin(obj.Angle); 
				cosA = cos(obj.Angle);
				x0 = S.Coordinate(1);
				y0 = S.Coordinate(2);
				% 有向距离差
				h = (x0*sinA - y0*cosA - obj.DirectionalOriginDistance)*2;
				% 反射: P' = P - 2*h*n, n=(sinA,-cosA)
				S = SymbolicMath.Point([x0 - h.*sinA; y0 + h.*cosA]);
			end
		end
	end
end