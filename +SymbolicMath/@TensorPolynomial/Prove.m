%[text] 从条件尝试推理结论
%[text] ## 语法
%[text] ```matlabCodeExample
%[text] Remainders = SymbolicMath.TensorPolynomial.Prove(Conditions,Conclusions)
%[text] ```
%[text] ## 输入参数
%[text] Conditions(:,1)SymbolicMath.TensorPolynomial，条件
%[text] Conclusions(:,1)SymbolicMath.TensorPolynomial，结论
%[text] ## 返回值
%[text] Remainders(:,1)SymbolicMath.TensorPolynomial，大小和结论一样，对应每条结论是否被成功推出。如果成功，对应位置是0；如果失败，则输出还需要额外满足的条件
function ConclusionRemainders = Prove(Conditions,ConclusionRemainders)
for Cc=1:numel(ConclusionRemainders)
	AnyConditionApplied=true;
	while AnyConditionApplied
		AnyConditionApplied=false;
		
	end
end
end

%[appendix]{"version":"1.0"}
%---
