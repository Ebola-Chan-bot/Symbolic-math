classdef Arc
	properties
		%圆心
		Center(2,1)

		%半径
		Radius(1,1)

		%从圆心指向弧中点的方向角(-π,π]
		DirectionAngle(1,1)

		%弧对应的圆心角[0,2π)
		CentralAngle(1,1)
	end
	methods
		function obj = Arc(Center,Radius,DirectionAngle,CentralAngle)
			switch nargin
				case 2
					obj.Center=Center.Center;
					obj.Radius=Center.Radius;
					if isa(Radius,'SymbolicMath.Point')
						Radius=[Radius.Coordinate];
					else
						Radius=sym(arrayfun(@string,Radius)+["1";"2"],'real');
					end
					uABC=Radius-Center.Center;
					uABC=uABC./vecnorm(uABC,2,1); % 转成单位向量

					% 有符号角（-pi, pi]
					angAC_signed = atan2( det(uABC(:,[1,3])) , dot(uABC(:,1),uABC(:,3)) );
					angAB_signed = atan2( det(uABC(:,[1,2])) , dot(uABC(:,1),uABC(:,2)) );

					% 方向因子: 1 表示沿 angAC_signed方向，-1 表示反向
					dirFactor = 1 - 2 * ( abs(angAB_signed) > abs(angAC_signed) );

					% 经过B的有符号弧角
					ang_viaB = angAC_signed * dirFactor;

					% 圆心角 [0, 2*pi)
					tmpAng = atan2(sin(ang_viaB), cos(ang_viaB)); % (-pi, pi]
					arcAngle = tmpAng + (tmpAng < 0) * 2*pi;      % 转到 [0, 2*pi)

					% 起点方向角
					angA = atan2(uA(2), uA(1));

					% 弧中点方向角 (-pi, pi]
					midDir = atan2( sin(angA + ang_viaB/2), cos(angA + ang_viaB/2) );

				case 4
					obj.Center = Center;
					obj.Radius = Radius;
					obj.DirectionAngle = DirectionAngle;
					obj.CentralAngle = CentralAngle;
			end
		end
	end
end