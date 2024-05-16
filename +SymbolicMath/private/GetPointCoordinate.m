function varargout=GetPointCoordinate(varargin)
NumDimensions=varargin{1};
if isnumeric(NumDimensions)&&isscalar(NumDimensions)
	varargin(1)=[];
else
	NumDimensions=0;
	for V=1:nargin
		Point=varargin{V};
		if isa(Point,'SymbolicMath.Point')
			NumDimensions=Point.NumDimensions;
			break;
		elseif isa(Point,'sym')||isnumeric(Point)
			NumDimensions=numel(Point);
			break;
		end
	end
	if ~NumDimensions
		NumDimensions=2;
	end
end
varargout=cell(1,nargout);
for V=1:nargout
	Point=varargin{V};
	if ischar(Point)||isstring(Point)
		Point=sym(Point,[1,NumDimensions]);
	elseif isa(Point,'SymbolicMath.Point')
		Point=Point.Coordinate;
	end
	varargout{V}=Point;
end
end