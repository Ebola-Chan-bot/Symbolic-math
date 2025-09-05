classdef Triangle
	properties
		%第1维XY坐标，第2维三个顶点
		Vertices(2,3)
	end

	methods
		function obj = Triangle(Vertices)
			%# 语法
			% ```
			% import SymbolicMath.Triangle;
			%
			% obj=Triangle(Vertices);
			% %给定三角形三点名称
			% ```
			%# 示例
			% ```
			% import SymbolicMath.Triangle;
			%
			% obj=Triangle('ABC');
			% %创建三角形ABC
			% ```
			%# 输入参数
			% Vertices(1,3)char，三个顶点的名称
			if ischar(Vertices)
				obj.Vertices=sym(arrayfun(@string,Vertices)+["1";"2"],'real');
			elseif isa(Vertices,'SymbolicMath.Point')
				obj.Vertices=[Vertices.Coordinate];
			else
				obj.Vertices=Vertices;
			end
		end
		function disp(obj)
			disp(obj.Vertices);
		end
		function C=Circumcircle(obj)
			% 使用行列式 (det) 公式计算外接圆圆心 C 与半径平方 R2
			V = obj.Vertices.';
			V(:,3)=1;
			s = sum(obj.Vertices.^2,1).';
			% 依据经典行列式表达式：
			C = [det([s,V(:,2),ones(3,1)]) ; det([s,V(:,1),ones(3,1)])] ./ (2*det(V));
			C=SymbolicMath.Circle(C,sqrt(sum((obj.Vertices(:,1)-C).^2)));
		end
	end
end