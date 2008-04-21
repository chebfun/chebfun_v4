function g = fun(op,n,scl)
% FUN	Constructor
% FUN(OP) constructs a fun object for the function OP.  If OP is a string,
% such as '3*x.^2+1', or a function handle, FUN(OP) automatically determines 
% the number of points for OP. If OP is a vector, FUN(OP) constructs a fun
% object such that its function values are the numbers in OP.
%
% FUN(OP,N) where N a positive integer creates a fun for OP with N Chebyshev 
% points. This option is not adaptive.
%
% FUN(OP,N,SCL) creates a fun for OP with at most N Chebyshev points
% adaptively.  Here SCL is a structure with fields SCL.H (horizontal scale)  
% and SCL.V (vertical scale). 
%
% FUN creates an empty fun.

persistent default_g
if isempty(default_g)
    default_g = ctor_ini;
    default_g = class(default_g,'fun');
end
g = default_g;
if      nargin == 1,    g = ctor_1(g,op);
elseif  nargin == 2,    g = ctor_2(g,op,n);
elseif  nargin == 3,    g = ctor_3(g,op,n,scl);
elseif  nargin > 3, error(['Class fun cannot be constructed from '...
        num2str(nargin) ' input arguments.']);
end