classdef Angle
	%角
	properties
		%顶点坐标
		Vertex(2,1)

		%顺时针方向，两个边的倾角(-π,π]
		Angles(1,2)
	end
	methods
		function obj = Angle(Vertex,Angles)
			switch nargin
				case 1
					if isa(Vertex,'SymbolicMath.Point')
						Vertex=[Vertex.Coordinate];
					else
						Vertex=sym(arrayfun(@string,Vertex)+["1";"2"],'real');
					end
					obj.Vertex=Vertex(:,2);
					Angles=Vertex(:,[1,3])-obj.Vertex;
					obj.Angles=atan2(Angles(2,:),Angles(1,:));
				case 2
					if isa(Vertex,'SymbolicMath.Point')
						obj.Vertex=Vertex.Coordinate;
						Angles=[Angles.Coordinate]-Vertex.Coordinate;
						obj.Angles=atan2(Angles(2,:),Angles(1,:));
					else
						obj.Vertex=Vertex;
						obj.Angles=Angles;
					end
			end
		end
		function SL=Bisector(obj)
			Angle=mean(obj.Angles);
			SL=SymbolicMath.StraightLine(Angle,obj.Vertex(1).*sin(Angle) - obj.Vertex(2).*cos(Angle));
		end
	end
end