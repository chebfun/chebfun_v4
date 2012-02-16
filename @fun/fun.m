% FUN	Class definition for funs
% FUN(OP,ENDS) constructs a fun object for the function OP.  If OP is a string,
% such as '3*x.^2+1', or a function handle, FUN(OP) automatically determines
% the number of points for OP. If OP is a vector, FUN(OP) constructs a fun
% object such that its function values are the numbers in OP.
%
% FUN(OP,ENDS,N) where N a positive integer creates a fun for OP with N Chebyshev
% points. This option is not adaptive.
%
% FUN(OP,ENDS,PREF,SCL) creates a fun for OP adaptively using the
% preferences provided in the structure PREF (see chebfunpref).  
% Here SCL is a structure with fields SCL.H (horizontal scale) and SCL.V 
% (vertical scale).
%
% Additionally, exponents can be pass within PREF by attaching them in a cell
% array to PREF.EXPS, and a non-adaptive call can be forced by setting
% PREF.N to be a positive integer.
%
% FUN creates an empty fun.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

classdef fun
    
    properties ( GetAccess = 'public' , SetAccess = 'public' )
        n = 0;         % The length of the fun
        vals = [];     % Fun values at Chebyshev points
        coeffs = [];   % Chebyshev coeffs of fun
        ends = [-1 1]; % Domain of the fun
        exps = [0 0];  % Exponents: f(x)=(x-a)^exps(1)*(b-x)*exps(b)*p(x)
        scl = struct('h',[],'v',[]); % Scale info (horizontal and vertical)
        map = struct('for',[],'inv',[],'der',[],'name',[],'par',[]); % map 
    end
    
    properties ( GetAccess = 'private' , SetAccess = 'private' )
        ish = true;    % Happiness indicator. Did fun converege happily?
    end
    
    methods
        
        function g = fun(varargin)
            if nargin == 0, return, end
            g = ctor(g,varargin{:});
        end
        
    end
end