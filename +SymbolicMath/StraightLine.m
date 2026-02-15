classdef StraightLine<handle
	%通过直线倾角和到原点的有向距离确定一条直线
	properties(SetAccess=immutable)
		%已知直线是该角的平分线。可能为空。
		BisectorOf
	end
	properties
		%直线上的已知点坐标，至少有1个
		KnownPoints(2,:)
	end
	methods
		function obj = StraightLine(AorP)
			%# 语法
			% ```
			% obj=SymbolicMath.StraightLine(Angle);
			% %取得角的平分线
			%
			% obj=SymbolicMath.StraightLine(KnownPoints);
			% %通过已知点构造一条直线
			% ```
			%# 输入参数
			% Angle(1,1)SymbolicMath.Angle，作为其平分线的角
			% KnownPoints(1,2)string，直线上已知的两个点名称
			arguments
				AorP(1,:)
			end
			switch numel(AorP)
				case 1
					obj.BisectorOf=AorP;
					obj.KnownPoints=AorP.Vertex;
				case 2
					obj.KnownPoints=SymbolicMath.TensorPolynomial(AorP+["_X";"_Y"]);
			end
		end
	end
end