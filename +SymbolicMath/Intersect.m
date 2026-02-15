%[text] 获取一组张量多项式，表示直线和圆交于两点
%[text] ## 语法
%[text] ```matlabCodeExample
%[text] TensorPolynomial=SymbolicMath.Intersect(Circle,StraightLine,PointPair);
%[text] ```
%[text] ## 输入参数
%[text] Circle(1,1)SymbolicMath.Circle，圆
%[text] StraightLine(1,1)SymbolicMath.StraightLine，直线
%[text] PointPair(1,2)string，两点名称
%[text] ## 返回值
%[text] TensorPolynomial(4,1)SymbolicMath.TensorPolynomial，四个多项式同时为零表示直线和圆交于两点
function TensorPolynomial = Intersect(Circle,StraightLine,PointPair)
arguments
	Circle
	StraightLine
	PointPair(1,2)string
end
PointPair=SymbolicMath.TensorPolynomial(PointPair+["_X";"_Y"]);
L = StraightLine.KnownPoints;
C = Circle.KnownPoints;
P = PointPair(:,1);
Q = PointPair(:,2);
d = L(:,2) - L(:,1);
v = C(:,2) - C(:,3);
w = C(:,1) - C(:,3);
u = C(:,1) - P;
t = C(:,2) - P;
Eq3 = sum(u.*w,1).*(v(1).*t(2)-v(2).*t(1)) + (u(1).*w(2)-u(2).*w(1)).*sum(v.*t,1);
u = C(:,1) - Q;
t = C(:,2) - Q;
Eq4 = sum(u.*w,1).*(v(1).*t(2)-v(2).*t(1)) + (u(1).*w(2)-u(2).*w(1)).*sum(v.*t,1);
% 共线条件：P、Q在直线上
% 共圆条件：P、Q在圆上（交比为实数）
TensorPolynomial = [d(1).*(P(2)-L(2,1)) - d(2).*(P(1)-L(1,1)); d(1).*(Q(2)-L(2,1)) - d(2).*(Q(1)-L(1,1)); Eq3; Eq4];
end

%[appendix]{"version":"1.0"}
%---
