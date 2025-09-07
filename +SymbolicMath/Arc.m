classdef Arc
	properties
		%圆心
		Center(2,1)

		%半径
		Radius(1,1)

		%从圆心指向弧中点的方向角(-π,π]
		MidpointAngle(1,1)

		%弧对应的圆心角[0,2π)
		SectorAngle(1,1) 
	end
	methods
		function obj = Arc(Center,Radius,MidpointAngle,SectorAngle)
			switch nargin
				case 2
					obj.Center=Center.Center;
					obj.Radius=Center.Radius;
					if isa(Radius,'SymbolicMath.Point')
						Radius=[Radius.Coordinate];
					else
						Radius=sym(arrayfun(@string,Radius)+["1";"2"],'real');
					end
					
					obj.MidpointAngle=atan2(Radius(:,2)-obj.Center);
					obj.SectorAngle=mod(atan2(Radius(1,:)-obj.Center)-atan2(Radius(3,:)-obj.Center),2*pi);
				case 4
					obj.Center = Center;
					obj.Radius = Radius;
					obj.MidpointAngle = MidpointAngle;
					obj.SectorAngle = SectorAngle;
			end
		end
	end
end