function V=Version
V.Me='v1.0.0';
V.MatlabExtension='v19.9.0';
V.MATLAB='R2025a';
persistent NewVersion
try
	if isempty(NewVersion)
		NewVersion=TextAnalytics.CheckUpdateFromGitHub('https://github.com/Ebola-Chan-bot/Symbolic-math/releases','埃博拉酱符号数学工具箱',V.Me);
	end
catch ME
	if ME.identifier~="MATLAB:undefinedVarOrClass"
		ME.rethrow;
	end
end
end