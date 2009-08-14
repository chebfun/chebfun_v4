function [g,ish] = fun(op,ends,varargin)
% FUN	Constructor
% FUN(OP,ENDS) constructs a fun object for the function OP.  If OP is a string,
% such as '3*x.^2+1', or a function handle, FUN(OP) automatically determines 
% the number of points for OP. If OP is a vector, FUN(OP) constructs a fun
% object such that its function values are the numbers in OP.
%
% FUN(OP,ENDS,N) where N a positive integer creates a fun for OP with N Chebyshev 
% points. This option is not adaptive.
%
% FUN(OP,ENDS,PREF,SCL) creates a fun for OP adaptively using the preferences
% provided in the structure PREF (see chbfunpref).  Here SCL is a structure 
% with fields SCL.H (horizontal scale) and SCL.V (vertical scale). 
%
% [G,ISH] = FUN(...) returns the constructed fun G and the boolean ISH,
% which is true if the construction is believed to have converged and false
% otherwise.
%
% FUN creates an empty fun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team. 
%   Last commit: $Author$: $Rev$:
%   $Date$:

persistent default_g
if isnumeric(default_g)
    % Generate an empty fun!
    default_g = struct('vals',[],'n',0);
    default_g.scl  = struct('h',[],'v',[]);
    default_g.map = struct('for',[],'inv',[],'der',[],'name',[],'par',[]);
    default_g = class(default_g,'fun');
end
g = default_g;        
ish = true;

if nargin > 0
    % deal with endpoints
    % Look for domain in the second argument.
    if nargin == 1
        error('fun:constructor:ends', ... 
            'Either endpoints or a map must be provided')
    end
    if ~isnumeric(ends)     % A map may optionally be passed in the second arg.
        g.map = ends;
        ends = ends.for([-1,1]);
    elseif isinf(ends(1)) || isinf(ends(2))
        g.map = unbounded(ends);
    else
        g.map = linear(ends);
    end
    
    % Set horizantal scale if not provided
    if nargin < 4
        hs = norm(ends,inf);
        if hs == inf
            hs = 1;
        end
        g.scl = struct('h',hs,'v',0);
    else
        g.scl = varargin{2};
    end

    switch class(op)
        case 'fun'      % returns the same fun
            g = op;
            if nargin > 2
                warning('fun:constructor:input',['Generating fun from fun or double object on the first' ...
                    ' input argument. Other arguments are not used.'])
            end
            return
        case 'double'   % assigns value to the Chebyshev points
             if min(size(op)) > 1
                error('fun:constructor:double','Only vector inputs are allowed')
            end
            g.vals = op(:); g.n = length(op); g.scl.v = max(g.scl.v, norm(op,inf));
            if nargin > 2
                warning('fun:constructor:input',['Generating fun from fun or double object on the first' ...
                    ' input argument. Other arguments are not used.'])
            end
            return
        case 'char'
            op = inline(op);
    end
    
    % Sort preferences
    switch nargin 
        case 2
            pref = chebfunpref; % Preferences not provided (retrieve from chebfunpref)
        case 3
            n = varargin{1};    % non-adaptive case (preferences not needed)
        case 4
            pref = varargin{1}; % Preferences provided (adaptive case)
        case 5
            error('fun:constructor:nargin','A FUN call can have at most 4 input arguments')
    end
      
    % Call constructor depending on narg
    if  nargin == 3,
        % non-adaptive case exact number of points provided
        % map might still be addapted for that number of points
        xvals = g.map.for(chebpts(n)); 
        xvals(1) = g.map.par(1);  xvals(end) = g.map.par(2);
        vals = op(xvals);
        g.vals = vals; g.n = n; g.scl.v = max(g.scl.v, norm(vals,inf));
    else
        % adaptive case
        % If map was provided in the chebfun call, overwrite previous
        % assignment.
        if isfield(pref,'map')
            g.map = pref.map;
        end
        [g,ish] = growfun(op,g,pref);
    end
    
end