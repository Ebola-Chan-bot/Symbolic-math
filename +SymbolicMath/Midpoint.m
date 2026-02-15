%[text] 获取一组张量多项式，表示点是弧的中点
%[text] ## 语法
%[text] ```matlabCodeExample
%[text] TensorPolynomial=SymbolicMath.Midpoint(Arc,PointName);
%[text] ```
%[text] ## 输入参数
%[text] Arc(1,1)SymbolicMath.Arc，弧
%[text] PointName(1,1)string，中点名
%[text] ## 返回值
%[text] TensorPolynomial(3,1)SymbolicMath.TensorPolynomial，三个多项式同时为零表示点是弧的中点
function TensorPolynomial = Midpoint(Arc,Point)
Point=SymbolicMath.TensorPolynomial(Point+["_X";"_Y"]);
A = Arc.KnownPoints(:,1);
B = Arc.KnownPoints(:,2);
C = Arc.KnownPoints(:,3);
pA = Point - A;
pC = Point - C;
% 共圆条件：M在ABC外接圆上
u = A - Point;
v = B - C;
w = A - C;
t = B - Point;
CA = C - A;
% 等弦条件：|MA|²=|MC|²，即M在AC的垂直平分线上
% 交比(A-M)(B-C)/((A-C)(B-M))为实数，即Im[(A-M)·conj(A-C)·(B-C)·conj(B-M)]=0
% 定向条件：M与B在弦AC同侧，(C-A)×(M-A)与(C-A)×(B-A)同号
TensorPolynomial = [sum(pA.*pA, 1) - sum(pC.*pC, 1); sum(u.*w,1).*(v(1).*t(2)-v(2).*t(1)) + (u(1).*w(2)-u(2).*w(1)).*sum(v.*t,1); (CA(1).*pA(2) - CA(2).*pA(1)) .* (CA(1).*(B(2)-A(2)) - CA(2).*(B(1)-A(1))) - SymbolicMath.TensorPolynomial("T"+replace(matlab.lang.internal.uuid,'-','_')).^2];
end

%[appendix]{"version":"1.0"}
%---
