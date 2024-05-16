classdef IsoscelesRightTriangle<SymbolicMath.IDimensional&SymbolicMath.IConditional
	%一个等腰直角三角形，定义为一个固定向量沿
	properties(SetAccess=immutable)
		ParietalVertex
		BaseVertexA
		BaseVertexB
		Condition
	end
	properties(Dependent,SetAccess=immutable)
		NumDimensions
	end
	properties(Dependent)
		WaistA
		WaistB
	end
	methods
		function obj = IsoscelesRightTriangle(ParietalVertex,BaseVertexA,BaseVertexB)
			%构造一个新的等腰直角三角形
			%# 语法
			% ```
			% obj=SymbolicMath.IsoscelesRightTriangle(ABString);
			% %指定一个二字符串，分别作为一个顶角和一个底角的点名称，另一个底角将由指定的底角绕顶角顺时针旋转90°得到。此方法得到的等腰直角三角形Condition为空。
			%
			% obj=SymbolicMath.IsoscelesRightTriangle(ABCString);
			% %指定一个三字符串，分别作为一个顶角和两个底角的点名称。此方法得到的等腰直角三角形将必须满足Condition方程才能成立。
			%
			% obj=SymbolicMath.IsoscelesRightTriangle(ParietalVertex,BaseVertexA);
			% %依次指定一个顶角和一个底角点，另一个底角将由指定的底角绕顶角顺时针旋转90°得到。此方法得到的等腰直角三角形Condition为空。
			%
			% obj=SymbolicMath.IsoscelesRightTriangle(ParietalVertex,BaseVertexA,BaseVertexB);
			% %依次指定一个顶角和两个底角点。此方法得到的等腰直角三角形将必须满足Condition方程才能成立。
			% ```
			%# 示例
			% ```
			% %以下两种构造方法完全等价，都能构造一个以A为顶角的等腰直角三角形：
			% obj=SymbolicMath.IsoscelesRightTriangle('A','B','C');
			% obj=SymbolicMath.IsoscelesRightTriangle('ABC');
			% ```
			%# 输入参数
			% ABString(1,2)char，指定两个字符，分别作为一个顶角和一个底角的点名称。这些点将被视为二维的。
			% ABCString(1,3)char，指定三个字符，分别作为一个顶角和两个底角的点名称。这些点将被视为二维的。
			% BaseAngleA,BaseAngleB,ParietalAngle(1,1)，依次指定两个底角和一个顶角点
			if nargin==1
				ABC=char(BaseAngleA);
				BaseAngleA=ABC(1);
				BaseAngleB=ABC(2);
				ParietalAngle=ABC(3);
			end
			obj.BaseAngleA=SymbolicMath.Point(BaseAngleA);
			obj.BaseAngleB=SymbolicMath.Point(BaseAngleB);
			obj.ParietalVertex=SymbolicMath.Point(ParietalAngle);
		end
		function Waist=get.WaistA(obj)
			Waist=SymbolicMath.FixedVector(obj.ParietalVertex,obj.BaseAngleA);
		end
		function Waist=get.WaistB(obj)
			Waist=SymbolicMath.FixedVector(obj.ParietalVertex,obj.BaseAngleB);
		end
		function ND=get.NumDimensions(obj)
			ND=obj.ParietalVertex.NumDimensions;
		end
		function Eqs=get.Equations(obj)
			Eqs=[obj.WaistA.SquareLength==obj.WaistA.SquareLength;SymbolicMath.Perpendicular(obj.WaistA,obj.WaistB)];
		end
	end
end