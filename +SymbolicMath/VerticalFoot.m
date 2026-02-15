%[text] 获取一组张量多项式，表示点是直线外一点到直线的垂足
%[text] ## 语法
%[text] ```matlabCodeExample
%[text] TensorPolynomial=SymbolicMath.VerticalFoot(VF,FromPoint,ToStraightLine);
%[text] ```
%[text] ## 输入参数
%[text] VF(1,1)string，垂足点名称
%[text] FromPoint(1,1)，直线外一点名称
%[text] ToStraightLine(1,1)SymbolicMath.StraightLine，直线
%[text] ## 返回值
%[text] TensorPolynomial(2,1)SymbolicMath.TensorPolynomial，两个多项式同时为零表示VF是FromPoint到ToStraightLine的垂足
function TensorPolynomial = VerticalFoot(VF,FromPoint,ToStraightLine)
VF=SymbolicMath.TensorPolynomial(VF+["_X";"_Y"]);
FromPoint=SymbolicMath.TensorPolynomial(FromPoint+["_X";"_Y"]);
L = ToStraightLine.KnownPoints;
d = L(:,2) - L(:,1);
FP = VF - FromPoint;
% 共线条件：VF在直线上
% 垂直条件：(VF - FromPoint) · d = 0
TensorPolynomial = [d(1).*(VF(2)-L(2,1)) - d(2).*(VF(1)-L(1,1)); sum(FP.*d, 1)];
end

%[appendix]{"version":"1.0"}
%---
