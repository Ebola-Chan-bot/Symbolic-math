classdef IConditional
	%表示一个图形只有在满足方程时才成立
	properties(Abstract,SetAccess=immutable)
		%此图形要求满足的方程，可以为空
		Condition
	end
end

