import SymbolicMath.*;
%[text] 给定△ABC且Ω是其外接圆。C'是C关于∠BAC平分线的对称点，N是包含A的BC弧中点，NC'与Ω交于K。H是C'到BC的垂足。证明：∠BKH=2∠ABC。
ABC=Triangle('ABC') %[output:09b0c14e]
Omega=ABC.Circumcircle %[output:06567998]
Cp=Angle('BAC').Bisector().Symmetry('C') %[output:9de64c55]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:09b0c14e]
%   data: {"dataType":"textualVariable","outputData":{"name":"ABC","value":"[A1, B1, C1]\n[A2, B2, C2]\n "}}
%---
%[output:06567998]
%   data: {"dataType":"textualVariable","outputData":{"name":"Omega","value":"  <a href=\"matlab:helpPopup('SymbolicMath.Circle')\" style=\"font-weight:bold\">Circle<\/a> - 属性:\n\n    Center: [2×1 sym]\n    Radius: (A2 + (- A1^2*B1 + A1^2*C1 + A1*B1^2 + A1*B2^2 - A1*C1^2 - A1*C2^2 - A2^2*B1 + A2^2*C1 - B1^2*C1 + B1*C1^2 + B1*C2^2 - B2^2*C1)\/(2*A1*B2 - 2*A2*B1 - 2*A1*C2 + 2*A2*C1 + 2*B1*C2 - 2*B2*C1))^2 + (A1 + (- A1^2*B2 + A1^2*C2 - A2^2*B2 + A2^2*C2 …\n"}}
%---
%[output:9de64c55]
%   data: {"dataType":"textualVariable","outputData":{"name":"Cp","value":"C1 - sin(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2)*(2*C1*sin(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2) + 2*A2*cos(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2) - 2*C2*cos(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2) - 2*A1*sin(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2))\nC2 + cos(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2)*(2*C1*sin(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2) + 2*A2*cos(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2) - 2*C2*cos(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2) - 2*A1*sin(atan2(B2 - A2, B1 - A1)\/2 + atan2(C2 - A2, C1 - A1)\/2))\n "}}
%---
