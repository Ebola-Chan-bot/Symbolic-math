classdef Angle
	%角
	properties
		%顶点坐标
		Vertex(2,1)

		%从顶点指向角平分线的方向角(-π,π]
		BisectorAngle(1,1)

		%角度大小
		Radian(1,1)
	end
	methods
		function obj = Angle(Vertex,BisectorAngle,Radian)
			switch nargin
				case 1
					if isa(Vertex,'SymbolicMath.Point')
						Vertex=[Vertex.Coordinate];
					else
						Vertex=sym(arrayfun(@string,Vertex)+["1";"2"],'real');
					end
					obj.Vertex=Vertex(:,2);
					obj.BisectorAngle=atan2(mean(Vertex(:,[1,3]),2)-obj.Vertex);
					obj.Radian=
				case 2
					obj.Vertex=Vertex.Coordinate;
					obj.BisectorAngle=atan2(mean([BisectorAngle.Coordinate],2)-obj.Vertex);
					obj.Radian=mod(atan2(BisectorAngle(1).Coordinate-obj.Vertex)-atan2(BisectorAngle(2).Coordinate-obj.Vertex),2*pi);
				case 3
					obj.Vertex=Vertex;
					obj.BisectorAngle=BisectorAngle;
					obj.Radian=Radian;
			end
		end
		function SL=Bisector(obj)
			Angle=mean(obj.Angles)+pi/2;
			SL=SymbolicMath.StraightLine(Angle,obj.Vertex(1).*cos(Angle) + obj.Vertex(2).*sin(Angle));
		end
	end
end