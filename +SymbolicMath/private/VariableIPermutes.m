function iPermutes = VariableIPermutes(VariableGroups)
[~,iPermutes]=MATLAB.Ops.UnionN(2,VariableGroups{:});
for V=1:nargin
	P=iPermutes{V}
	iPermutes{V}=[P,setdiff(1:max(P),P)];
end
end