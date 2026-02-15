%[text] 获取一组张量多项式，表示两点关于直线对称
%[text] ## 语法
%[text] ```matlabCodeExample
%[text] TensorPolynomial=SymbolicMath.Symmetry(PointPair,StraightLine);
%[text] ```
%[text] ## 输入参数
%[text] PointPair(1,2)string，两个点的名称
%[text] StraightLine(1,1)SymbolicMath.StraightLine，对称轴
%[text] ## 返回值
%[text] TensorPolynomial(3,1)SymbolicMath.TensorPolynomial，三个多项式同时为零表示两点关于直线对称
function TensorPolynomial = Symmetry(PointPair,StraightLine)
arguments
	PointPair(1,2)string
	StraightLine
end
PointPair=SymbolicMath.TensorPolynomial(PointPair+["_X";"_Y"]);
Angle = StraightLine.BisectorOf;
V = Angle.Vertex;
a = Angle.SideVectors(:,1);
b = Angle.SideVectors(:,2);
p = PointPair(:,1) - V;
q = PointPair(:,2) - V;
% 点积与叉积
pa = sum(p.*a, 1);
qb = sum(q.*b, 1);
pxa = p(1).*a(2) - p(2).*a(1);
qxb = q(1).*b(2) - q(2).*b(1);
% 等距条件：|p|²=|q|²
% 等角条件：Im(p·conj(a)·q·conj(b))=0
% 定向条件：Re(p·conj(a)·q·conj(b))≥0，用非负松弛变量实现
TensorPolynomial = [sum(p.*p, 1) - sum(q.*q, 1); pa.*qxb + pxa.*qb; pa.*qb - pxa.*qxb - SymbolicMath.TensorPolynomial("T"+replace(matlab.lang.internal.uuid,'-','_')).^2];
end

%[appendix]{"version":"1.0"}
%---
