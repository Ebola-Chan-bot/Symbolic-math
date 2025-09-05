classdef Vectorizable
	methods(Access=protected,Abstract)
		obj=sym_(obj)
		obj=simplify_(obj)
	end
	methods(Abstract)
		obj=plus(objA,objB)
		obj=times(objA,objB)
	end
	methods
		function obj=sym(obj)
			obj=arrayfun(@sym_,obj);
		end
		function obj=simplify(obj)
			obj=arrayfun(@simplify_,obj);
		end
		function disp(obj)
			disp(obj.sym);
		end
		function AR=AccumulateReduce(obj,Function,Dimension)
			Subs=repmat({':'},1,max(ndims(obj),Dimension));
			Subs{Dimension}=1;
			AR=obj(Subs{:});
			for I=2:size(obj,Dimension)
				Subs{Dimension}=I;
				AR=Function(AR,obj(Subs{:}));
			end
		end
		function obj=sum(obj,Dimension)
			obj=obj.AccumulateReduce(@plus,Dimension);
		end
		function obj=prod(obj,Dimension)
			obj=obj.AccumulateReduce(@times,Dimension);
		end
		function obj=mtimes(objA,objB)
			if size(objA,2)==size(objB,1)
				obj=permute(sum(objA.*shiftdim(objB,-1),2),[1,3,2]);
			else
				SymbolicMath.Exception.mtimes_dimension_mismatch.Throw;
			end
		end
		function obj=power(obj,exponent)
			if exponent
				O=obj;
				for I=2:exponent
					obj=obj.*O;
				end
			end
		end
		function obj=mpower(obj,exponent)
			if exponent
				O=obj;
				for I=2:exponent
					obj=obj*O;
				end
			end
		end
	end
end