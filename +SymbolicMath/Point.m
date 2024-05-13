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
			%# 语法
			% ```
			% import SymbolicMath.Point
			%
			% obj=Point(OldPoint);
			% %使用已有Point构造新Point
			%
			% obj=Point(Name);
			% %使用指定名称构造新2维Point
			%
			% obj=Point(Name,NumDimensions);
			% %使用指定名称和维数构造新Point
			%
			% obj=Point(Coordinate);
			% %使用指定坐标构造新Point
			% ```
			%# 输入参数
			% OldPoint(1,1)Point，将构造一个与输入完全相同的新Point
			% Name(1,1)string，点的名称，不应与其它点冲突
			% NumDimensions(1,1)=2，点的维数
			% Coordinate(1,:)，sym或数值类型，点的各维坐标
			arguments
				Point
				NumDimensions=2
			end
			if isa(Point,'SymbolicMath.Point')
				obj=Point;
			else
				try
					obj.Coordinate=sym(Point,[1,NumDimensions]);
				catch ME
					if any(ME.identifier==["symbolic:sym:SimpleVariable","MATLAB:validators:mustBeText"])
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
			Vector=SymbolicMath.FixedVector(A.Coordinate-B.Coordinate);
		end
	end
end