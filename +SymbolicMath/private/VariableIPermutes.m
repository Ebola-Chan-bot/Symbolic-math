function [VariableNames,iPermutes] = VariableIPermutes(VariableGroups)
[VariableNames,iPermutes]=MATLAB.Ops.UnionN(2,VariableGroups{:});
iPermutes=cellfun(@(P)[P,setdiff(1:max(P),P)],iPermutes,UniformOutput=false);
end