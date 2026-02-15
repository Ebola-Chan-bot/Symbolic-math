%[text] 获取一组张量多项式，表示一个角是另一个角的2倍大小
%[text] ## 语法
%[text] ```matlabCodeExample
%[text] TensorPolynomial=SymbolicMath.VerticalFoot(TAngle,OAngle);
%[text] ```
%[text] ## 输入参数
%[text] TAngle(1,1)SymbolicMath.Angle，二倍大小的角
%[text] OAngle(1,1)SymbolicMath.Angle，一倍大小的角
%[text] ## 返回值
%[text] TensorPolynomial(2,1)SymbolicMath.TensorPolynomial，两个多项式同时为零表示TAngle的大小是OAngle的2倍
function TensorPolynomial = TwiceAngle(TAngle,OAngle)
a = OAngle.SideVectors(:,1);
b = OAngle.SideVectors(:,2);
c = TAngle.SideVectors(:,1);
d = TAngle.SideVectors(:,2);
% 复数表示：z₁=b·conj(a), z₂=d·conj(c)
% 二倍角条件：arg(z₂)=2·arg(z₁)，即 z₂/z₁² 为正实数
ba_dot = sum(b.*a, 1);
ba_cross = b(1).*a(2) - b(2).*a(1);
dc_dot = sum(d.*c, 1);
dc_cross = d(1).*c(2) - d(2).*c(1);
% z₁²的实部 = (b·a)²-(b×a)²，虚部 = 2(b·a)(b×a)
R1 = ba_dot.*ba_dot - ba_cross.*ba_cross;
I1 = ba_dot.*ba_cross;
% Im(z₂·conj(z₁²)) = 0
% Re(z₂·conj(z₁²)) ≥ 0
TensorPolynomial = [dc_cross.*R1 - dc_dot.*I1 - dc_dot.*I1; dc_dot.*R1 + dc_cross.*I1 + dc_cross.*I1 - SymbolicMath.TensorPolynomial("T"+replace(matlab.lang.internal.uuid,'-','_')).^2];
end

%[appendix]{"version":"1.0"}
%---
