classdef IsoscelesRightTriangle<SymbolicMath.IDimensional&SymbolicMath.IConditional
	%一个等腰直角三角形
	properties(SetAccess=immutable)
		BaseAngleA
		BaseAngleB
		ParietalAngle
	end
	properties(Dependent,SetAccess=immutable)
		NumDimensions
	end
	properties(Dependent,SetAccess=protected)
		Equations
	end
	properties(Dependent)
		WaistA
		WaistB
	end
	methods
		function obj = IsoscelesRightTriangle(BaseAngleA,BaseAngleB,ParietalAngle)
			%构造一个新的等腰直角三角形
			%# 语法
			% ```
			% obj=SymbolicMath.IsoscelesRightTriangle(BaseAngleA,BaseAngleB,ParietalAngle);
			% %依次指定两个底角和一个顶角点
			%
			% obj=SymbolicMath.IsoscelesRightTriangle(ABCString);
			% %指定一个三字符串，分别作为两个底角和一个顶角的点名称
			% ```
			%# 示例
			% ```
			% %以下两种构造方法完全等价，都能构造一个以C为顶角的等腰直角三角形：
			% obj=SymbolicMath.IsoscelesRightTriangle('A','B','C');
			% obj=SymbolicMath.IsoscelesRightTriangle('ABC');
			% ```
			%# 输入参数
			% BaseAngleA,BaseAngleB(1,1)，底角点名称string或Point对象
			% ParietalAngle(1,1)，顶角点名称string或Point对象
			% ABCString(1,3)char，指定三个字符，分别作为两个底角和一个顶角的点名称
			if nargin==1
				ABC=char(BaseAngleA);
				BaseAngleA=ABC(1);
				BaseAngleB=ABC(2);
				ParietalAngle=ABC(3);
			end
			obj.BaseAngleA=SymbolicMath.Point(BaseAngleA);
			obj.BaseAngleB=SymbolicMath.Point(BaseAngleB);
			obj.ParietalAngle=SymbolicMath.Point(ParietalAngle);
		end
		function Waist=get.WaistA(obj)
			Waist=obj.BaseAngleA-obj.ParietalAngle;
		end
		function Waist=get.WaistB(obj)
			Waist=obj.BaseAngleB-obj.ParietalAngle;
		end
		function ND=get.NumDimensions(obj)
			ND=obj.ParietalAngle.NumDimensions;
		end
		function Eqs=get.Equations(obj)
			Eqs=[obj.WaistA.SqAbs==obj.WaistA.SqAbs;Perpendicular(obj.WaistA,obj.WaistB)];
		end
	end
end