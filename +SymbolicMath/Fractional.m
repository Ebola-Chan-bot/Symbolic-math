classdef Fractional<SymbolicMath.Vectorizable
	properties
		Numerator SymbolicMath.TensorPolynomial
		Denominator SymbolicMath.TensorPolynomial
	end
	methods(Static,Access=protected)
		function obj = Fractional_(Numerator, Denominator)
			obj=SymbolicMath.Fractional;
			if nargin<2
				if isa(Numerator,'sym')
					[obj.Numerator,obj.Denominator]=numden(Numerator);
				else
					obj.Numerator=Numerator;
					obj.Denominator=1;
				end
			else
				obj.Numerator = Numerator;
				obj.Denominator = Denominator;
			end
		end
	end
	methods(Access=protected)
		function S=sym_(obj)
			S = obj.Numerator.sym__ ./ obj.Denominator.sym__;
		end
		function objA=plus_(objA,objB)
			arguments
				objA
				objB SymbolicMath.Fractional
			end
			if eq_(objA.Denominator,objB.Denominator)
				objA.Numerator = plus_(objA.Numerator,objB.Numerator);
			else
				objA.Numerator = plus_(times_(objA.Numerator,objB.Denominator), times_(objB.Numerator,objA.Denominator));
				objA.Denominator = times_(objA.Denominator,objB.Denominator);
			end
		end
		function objA=minus_(objA,objB)
			arguments
				objA
				objB SymbolicMath.Fractional
			end
			if eq_(objA.Denominator,objB.Denominator)
				objA.Numerator = minus_(objA.Numerator,objB.Numerator);
			else
				objA.Numerator = minus_(times_(objA.Numerator,objB.Denominator), times_(objB.Numerator,objA.Denominator));
				objA.Denominator = times_(objA.Denominator,objB.Denominator);
			end
		end
		function objA=times_(objA,objB)
			arguments
				objA
				objB SymbolicMath.Fractional
			end
			objA.Numerator = times_(objA.Numerator,objB.Numerator);
			objA.Denominator = times_(objA.Denominator,objB.Denominator);
		end
		function obj=simplify_(obj)
			[obj.Numerator,obj.Denominator]=numden(obj.sym_);
		end
		function TF=eq_(objA,objB)
			arguments
				objA
				objB SymbolicMath.Fractional
			end
			TF=eq_(times_(objA.Numerator,objB.Denominator),times_(objB.Numerator,objA.Denominator));
		end
	end
	methods
		function obj = Fractional(varargin)
			if nargin
				obj = MATLAB.DataTypes.ArrayFun(@SymbolicMath.Fractional.Fractional_,varargin{:});
			end
		end
		function obj=plus(objA,objB)
			obj=MATLAB.DataTypes.ArrayFun(@plus_,objA,objB);
		end
		function obj=minus(objA,objB)
			obj=MATLAB.DataTypes.ArrayFun(@minus_,objA,objB);
		end
		function obj=times(objA,objB)
			obj=MATLAB.DataTypes.ArrayFun(@times_,objA,objB);
		end
		function TF=eq(objA,objB)
			TF=MATLAB.DataTypes.ArrayFun(@eq_,objA,objB);
		end
	end
end