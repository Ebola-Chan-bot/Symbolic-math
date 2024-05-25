classdef LinearObject
	%线性对象，指各维坐标满足一系列线性等式的点的集合
	properties(SetAccess=immutable)
		%参数方程系数，以矩阵表示。第1维表示对象的各个空间维度，第2维表示各个参数的系数
		ParametricCoefficients
		%参数方程截距，以列向量表示各维截距
		Interceptions(:,1)
	end
	properties(Dependent)
		%线性对象自身的维度，即参数方程的参数个数。如点是0，线是1，面是2
		SelfDimension
		%线性对象所在空间的维度，即参数方程组的方程个数。如平面坐标系是2，空间坐标系是3
		SpatialDimension
	end
	methods
		function obj = LinearObject(ParametricCoefficients,Interceptions)
			obj.ParametricCoefficients=ParametricCoefficients;
			obj.Interceptions=Interceptions;
		end
		function SD=get.SpatialDimension(obj)
			SD=height(obj.ParametricCoefficients);
		end
		function SD=get.SelfDimension(obj)
			SD=width(obj.ParametricCoefficients);
		end
		function obj=intersect(varargin)
			%求多个线性对象的交集。这些线性对象必须具有相同的空间维度。
			obj=[varargin{:}];
			NumObjects=numel(obj);
			Intersection=[obj.ParametricCoefficients];
			[SpaceDimension,NumParameters]=size(Intersection);
			FullDimensions=SpaceDimension*NumObjects;
			if isa(Intersection,'sym')
				PC=zeros(FullDimensions,NumParameters,'sym');
				Ic=zeros(FullDimensions,1,'sym');
			else
				PC=zeros(FullDimensions,NumParameters);
				Ic=zeros(FullDimensions,1);
			end
			ParametersDone=obj(1).SelfDimension;
			PC(1:SpaceDimension,1:ParametersDone)=obj(1).ParametricCoefficients;
			DimensionsDone=0;
			DimensionSpan=SpaceDimension*2;
			for O=2:NumObjects
				objO=obj(O);
				PC(DimensionsDone+1:DimensionsDone+DimensionSpan,ParametersDone+1:ParametersDone+objO.SelfDimension)=repmat(objO.ParametricCoefficients,2,1);
				Ic(DimensionsDone+1:DimensionsDone+SpaceDimension)=obj(O-1).Interceptions-objO.Interceptions;
				DimensionsDone=DimensionsDone+SpaceDimension;
				ParametersDone=ParametersDone+objO.SelfDimension;
			end
			
		end
	end
end