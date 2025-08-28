classdef Polygon
	%表示一个多边形
	properties
		%变量名
		VariableNames

		%共面约束多项式张量
		PolynomialTensors
	end
	methods
		function obj = Polygon(NumDimensions,Points)
			%输入空间维度
			switch nargin
				case 1
					Points=NumDimensions;
					NumDimensions=unique([Points.NumDimensions]);
					SymbolicMath.Exception.Different_vertex_dimensions.Assert(isscalar(NumDimensions));
				case 2
					if~isa(Points,'SymbolicMath.Point')
						Points=SymbolicMath.Point.Points(NumDimensions,Points);
					end
			end
			[obj.VariableNames,iPermutes]=VariableIPermutes({Points.VariableNames});

		end

		function outputArg = method1(obj,inputArg)
			%METHOD1 此处显示有关此方法的摘要
			%   此处显示详细说明
			outputArg = obj.Property1 + inputArg;
		end
	end
end