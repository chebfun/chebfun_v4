function f = chebfun(varargin)
% CHEBFUN   Constructor
%
% CHEBFUN(f) constructs a chebfun object for the function f on the
% interval [-1,1].  f can be a string, e.g 'sin(x)', a function handle, e.g
% @(x) x.^2 + 2x +1, or a number.  If f is a doubles array, [a1;a2;...;an],
% the numbers a1,...,an are used as the function values at Chebyshev 
% points. 
%
% CHEBFUN(f,[a b]) specifies an interval [a b] where the function is
% defined. 
%
% CHEBFUN(f,np) overrides the adaptive construction process to specify
% the number np of Chebyshev points to construct the chebfun.
% CHEBFUN(f,[a b],np) specifies the interval of definition and the
% number np of Chebyshev points. 
% 
% CHEBFUN(f1,f2,...,fm,ends), where ends is an increasing vector of length
% m+1, constructs a piecewise smooth chebfun from the functions f1,...,fm. 
% Each funcion fi can be a string, a function handle or a doubles array, 
% and is defined in the interval [ends(i) ends(i+1)]. 
%
% CHEBFUN(f1,f2,...,fm,ends,np), where np is a vector of length m, specifies
% the number np(i) of Chebyshev points for the construction of fi.
% 
% CHEBFUN(chebs,ends) construct a piecewise smooth chebfun with m pieces
% from a cell array chebs of size m x 1.  Each entry chebs{i} 
% is a function defined on [ends(i) ends(i+1)] represented by a
% string, a function handle or a number.  CHEBFUN(chebs,ends,np)
% specifies the number np(i) of Chebyshev points for the construction
% of the function in chebs{i}.
%
% CHEBFUN creates an empty fun.
%
% F = CHEBFUN(...) returns an object F of type chebfun.  A chebfun consists
% of a vector of 'funs', a vector 'ends' of length m+1 defining the 
% intervals where the funs apply, and a matrix 'imps'containing information
% about possible delta functions at the breakpoints between funs.

persistent default_f
if isempty(default_f)
    default_f = ctor_ini;
    default_f = class(default_f,'chebfun');
end
f = default_f;
if      nargin == 1,    
    f = ctor_1(f,varargin{1});
elseif nargin > 1
    if ~iscell(varargin{1})
        varargin = unwrap_arg(varargin{:});
    end
    if  length(varargin) == 2,    
        f = ctor_2(f,varargin{:});
    elseif length(varargin) == 3,
        f = ctor_3(f,varargin{:});
    end
end