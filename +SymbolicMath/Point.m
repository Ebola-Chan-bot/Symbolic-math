classdef Point<SymbolicMath.IDimensional
	%点
	properties(SetAccess=immutable)
		%坐标向量
		Coordinate
	end
	properties(Dependent,SetAccess=immutable)
		%点的维度，即坐标向量的长度
		NumDimensions
	end
	methods
		function obj = Point(Point,NumDimensions)
			arguments
				Point
				NumDimensions=2
			end
			%使用坐标创建点。坐标可以是数值或符号向量。向量的长度即为点的维度
			if isa(Point,'SymbolicMath.Point')
				obj=Point;
			else
				try
					obj.Coordinate=sym(Point,[1,NumDimensions]);
				catch ME
					if ME.identifier=="symbolic:sym:SimpleVariable"
						obj.Coordinate=Point;
					else
						ME.rethrow;
					end
				end
			end
		end
		function ND=get.NumDimensions(obj)
			ND=numel(obj.Coordinate);
		end
		function Vector=minus(A,B)
			Vector=SymbolicMath.Vector(A.Coordinate-B.Coordinate);
		end
		function Equation=OnVector(Vector)
		end
	end
end