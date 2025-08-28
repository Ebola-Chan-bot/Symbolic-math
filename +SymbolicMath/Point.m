classdef Point<SymbolicMath.IDimensional
	%点
	properties(SetAccess=immutable)
		%坐标张量，第1维是维数，后续维度是多项式张量
		Coordinate

		%对应 Coordinate 2:end 维度的变量名称
		VariableNames
	end
	properties(Dependent,SetAccess=immutable)
		%点的维度，即坐标向量的长度
		NumDimensions
	end
	methods
		function obj = Point(NumDimensions,Name)
			obj.VariableNames=Name+string(1:NumDimensions);
			obj.Coordinate=zeros([NumDimensions,repmat(2,1,NumDimensions)]);
			obj.Coordinate(bitshift(NumDimensions,0:NumDimensions-1)+(1:NumDimensions))=1;
		end
		function ND=get.NumDimensions(obj)
			ND=size(obj.Coordinate,1);
		end
	end
	methods(Static)
		function obj=Points(NumDimensions,Names)
			obj=arrayfun(@(Name)SymbolicMath.Point(NumDimensions,Name),Names);
		end
	end
end