classdef ILength<SymbolicMath.IDimensional
	%表示一个有长度的抽象对象
	properties(Abstract,SetAccess=immutable)
		%长度
		Length
		%长度的平方
		SquareLength
	end
end