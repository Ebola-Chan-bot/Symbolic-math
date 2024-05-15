classdef StraightLine<SymbolicMath.IDimensional
	properties(SetAccess=immutable)
		Coefficients(1,:)
		Intercept
	end
	properties(SetAccess=immutable)
		NumDimensions
	end
	methods
		function ND=get.NumDimensions(obj)
			ND=numel(obj.Coefficients);
		end
		function obj = StraightLine(Coefficients,Intercept)
			%# 语法
			% ```
			% import SymbolicMath.StraightLine
			%
			% obj=StraightLine(StraightLine);
			% %从已有直线拷贝
			%
			% obj=StraightLine(FixedVector);
			% %获取固定向量所在的直线
			%
			% obj=StraightLine(ABString);
			% %从二字符串指定的两点确定一条直线
			%
			% obj=StraightLine(PointA,PointB);
			% %从指定的两点确定一条直线
			%
			% obj=StraightLine(Coefficients,Intercept);
			% %指定各维系数和截距以确定一条直线
			% ```
			%# 输入参数
			% StraightLine(1,1)StraightLine，要拷贝的直线
			% FixedVector(1,1)FixedVector，用于确定直线的固定向量
			% ABString(1,2)char，以二字符串的形式指定直线上两点的名称，这要求两点必须具有单字符名称
			% PointA,PointB，用于确定直线的两点，可以是Point或点名称字符串
			% Coefficients(1,:)，各维系数，可以是sym或数值类型。例如直线ax+by=c的Coefficients就是[a,b]
			% Intercept(1,1)，截距，可以是sym或数值类型。例如直线ax+by=c的Intercept就是c
			%# 特别提示
			% 点名称不是点变量名。如果要使用没有名称的点，则不能使用点名称相关的语法构造
			if isa(Coefficients,'SymbolicMath.StraightLine')
				obj=Coefficients;
			elseif isa(Coefficients,'SymbolicMath.FixedVector')
				PointMatrix=[Coefficients.StartPoint.Coordinate;Coefficients.EndPoint.Coordinate];
				
			end
		end
	end
end