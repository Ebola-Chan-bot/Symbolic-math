%[text] 获取一个点关于直线的镜像
%[text] ## 语法
%[text] ```matlabCodeExample
%[text] Point=SymbolicMath.Symmetry(Point,StraightLine);
%[text] ```
%[text] ## 输入参数
%[text] Point(1,1)char，点的名称
%[text] StraightLine(1,1)SymbolicMath.StraightLine，对称轴
%[text] ## 返回值
%[text] Point(1,1)SymbolicMath.Point，镜像点
function Point = Symmetry(Point,StraightLine)
Point=SymbolicMath.Point(Point,StraightLine);
end

%[appendix]{"version":"1.0"}
%---
