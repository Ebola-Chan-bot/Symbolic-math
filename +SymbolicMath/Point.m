classdef Point
	%POINT undefined
	%   undefined
	
	properties
		Property1
	end
	
	methods
		function obj = Point(inputArg1,inputArg2)
			%POINT undefined
			%   undefined
			obj.Property1 = inputArg1 + inputArg2;
		end
		
		function outputArg = method1(obj,inputArg)
			%METHOD1 undefined
			%   undefined
			outputArg = obj.Property1 + inputArg;
		end
	end
end