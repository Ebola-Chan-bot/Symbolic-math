classdef Angle
	%角
	properties
		%顶点坐标
		Vertex(2,1)

		%从顶点指向角平分线的方向角(-π,π]
		BisectorAngle(1,1)

		%角度大小[0,2π)
		Radian(1,1)
	end
	methods
		function obj = Angle(Vertex,BisectorAngle,Radian)
			%# 语法
			% ```
			% import SymbolicMath.Angle;
			%
			% obj=Angle(ABC);
			% %给定三点ABC或名称，构造∠ABC
			%
			% obj=Angle(B,AC);
			% %给定顶点B和两条边上两点AC，构造∠ABC
			%
			% obj=Angle(Vertex,BisectorAngle,Radian);
			% %给定顶点坐标、角平分线方向角和角度大小，构造角
			% ```
			%# 输入参数
			% ABC(1,3)SymbolicMath.Point|char，三个点或名称
			% B(1,1)SymbolicMath.Point，顶点
			% AC(1,2)SymbolicMath.Point，角两边上两点
			% Vertex(2,1)，顶点坐标
			% BisectorAngle(1,1)，从顶点指向角平分线的方向角(-π,π]
			% Radian(1,1)，角度大小
			switch nargin
				case 1
					if isa(Vertex,'SymbolicMath.Point')
						Vertex=[Vertex.Coordinate];
					else
						Vertex=sym(arrayfun(@string,Vertex)+["1";"2"],'real');
					end
					obj.Vertex=Vertex(:,2);
					% 向量 BA 和 BC
					BA = Vertex(:,1) - Vertex(:,2);
					BC = Vertex(:,3) - Vertex(:,2);

					% 计算∠ABC的大小
					normBA = norm(BA);
					normBC = norm(BC);
					obj.Radian = acos(dot(BA, BC) / (normBA * normBC)); % 弧度值 [0,pi]

					% 计算角平分线方向向量
					bisector_vec = BA / normBA + BC / normBC;

					obj.BisectorAngle = atan2(bisector_vec(2), bisector_vec(1)); % (-pi,pi]
				case 3
					obj.Vertex=Vertex;
					obj.BisectorAngle=BisectorAngle;
					obj.Radian=Radian;
			end
		end
		function SL=Bisector(obj)
			Angle = atan2(sin(obj.BisectorAngle+pi/2), cos(obj.BisectorAngle+pi/2));
			SL=SymbolicMath.StraightLine(Angle,obj.Vertex(1)*cos(Angle) + obj.Vertex(2)*sin(Angle));
		end
	end
end