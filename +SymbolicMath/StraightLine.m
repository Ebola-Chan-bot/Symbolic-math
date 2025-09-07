classdef StraightLine
	%通过从原点垂直指向直线的法向量确定一条直线
	properties
		%法向量的倾角（不是直线的倾角），(-π,π]
		Angle(1,1)

		%到原点的有向距离
		%直线上任一点(X,Y)满足X.*cos(Angle)+Y.*sin(Angle)==DirectionalOriginDistance
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
				UnitNormalVector = [cos(obj.Angle); sin(obj.Angle)];
				S = SymbolicMath.Point(S.Coordinate+2*(obj.DirectionalOriginDistance-dot(UnitNormalVector,S.Coordinate))*UnitNormalVector);
			end
		end
	end
end