classdef FreeVector<SymbolicMath.Point&SymbolicMath.ILength
	%自由向量，不具有固定的起点和终点，只有长度和方向定义
	properties(Dependent,SetAccess=immutable)
		Length
		SquareLength
	end
	methods
		function obj = FreeVector(Coordinate)
			%从坐标构造对象
			%此类的构造方法仅支持从坐标构造。更灵活的创建对象方法请使用静态方法New
			%# 语法
			% ```
			% obj=SymbolicMath.FreeVector(Coordinate);
			% ```
			%# 输入参数
			% Coordinate(1,:)，向量各维坐标，可以是sym或数值类型
			obj@SymbolicMath.Point(Coordinate);
		end
		function SL=get.SquareLength(obj)
			SL=obj.Coordinate*obj.Coordinate.';
		end
		function L=get.Length(obj)
			L=sqrt(obj.SquareLength);
		end
	end
	methods(Static)
		function obj=New(obj,EndPoint)
			%创建一个自由向量
			%# 语法
			% ```
			% import SymbolicMath.FreeVector.New
			%
			% obj=New(Vector);
			% %从已有的固定或自由向量创建
			%
			% obj=New(Coordinate);
			% %从坐标创建
			%
			% obj=New(ABString);
			% %从二字符串创建
			%
			% obj=New(StartPoint,EndPoint);
			% %从已有的起点和终点创建
			% ```
			%# 输入参数
			% Vector(1,1)，可以是FreeVector或FixedVector，用于创建相同的新对象
			% Coordinate(1,:)，向量的各维坐标，可以是sym或数值类型
			% ABString(1,2)char，以二字符串的形式指定起点和终点名称。这要求起点和终点都具有单字符名称。
			% StartPoint,EndPoint(1,1)，分别指定起点和终点。
			% - 如果指定为Point，则将以指定的Point作为起点和终点
			% - 如果指定为string，则将以指定的字符串作为起点和终点的名称
			%# 返回值
			% obj(1,1)FreeVector，新建的向量
			%# 特别提示
			% 点名称不是点变量名。如果要使用没有名称的点，则不能使用点名称相关的语法构造。如果使用起点和终点创建，此对象仅记录起点和终点的相对位置关系，不记录点的具体
			%  位置。如需通过对象找回起点和终点，必须使用FixedVector。
			if ~isa(obj,'SymbolicMath.FreeVector')
				if isa(obj,'sym')||isnumeric(obj)
					obj=SymbolicMath.FreeVector(obj);
				else
					if isa(obj,'SymbolicMath.FixedVector')
						EndPoint=obj.EndPoint;
						obj=obj.StartPoint;
					elseif nargin==1
						obj=char(obj);
						EndPoint=obj(2);
						obj=obj(1);
					end
					obj=SymbolicMath.FreeVector(SymbolicMath.Point(EndPoint).Coordinate-SymbolicMath.Point(obj).Coordinate);
				end
			end
		end
	end
end