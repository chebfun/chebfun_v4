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
    default_g = struct('vals',[],'n',0,'exps',[0 0]);
    default_g.scl  = struct('h',[],'v',[]);
    default_g.map = struct('for',[],'inv',[],'der',[],'name',[],'par',[]);
    default_g = class(default_g,'fun');
end
g = default_g;
ish = true;

if nargin == 0, return; end  % Return empty fun

%% Look for domain in the second argument.
if nargin == 1
    if isa(op,'fun'), g = op; return, end      % returns the same fun
    error('fun:constructor:ends','Either endpoints or a map must be provided')
end

if nargin == 2
     % Preferences not provided
     pref = chebfunpref;
else
    pref = varargin{1};
    % Non-adaptive case (preferences not needed)
    if ~isa(pref,'struct'), 
        n = pref;
        pref = chebfunpref;
    end
end

%% Deal with endpoints and maps
if ~isnumeric(ends)     % A map may optionally be passed in the second arg.
    g.map = ends;
    ends = ends.for([-1,1]);
elseif any(isinf(ends))
    g.map = unbounded(ends);
else
    g.map = linear(ends);
end

%% Set horizantal scale if not provided
if nargin < 4 || isempty(varargin{2})
    hs = norm(ends,inf);
    if hs == inf
        hs = 1;
    end
    g.scl = struct('h',hs,'v',0);
else
    g.scl = varargin{2};
end

%% Deal with input op type
switch class(op)
    case 'fun'      % returns the same fun
        g = op;
        if nargin > 2
            warning('fun:constructor:input',['Generating fun from fun on the first' ...
                ' input argument. Other arguments are not used.'])
        end
        return
    case 'double'   % assigns value to the Chebyshev points
        if min(size(op)) > 1
            error('fun:constructor:double','Only vector inputs are allowed')
        end
        g.vals = op(:); g.n = length(op); g.scl.v = max(g.scl.v, norm(op,inf)); 
        g.exps = [0 0]; % Can't deal with blow up for numeric input
        if nargin > 2
            warning('fun:constructor:input',['Generating fun from double object on the first' ...
                ' input argument. Other arguments are not used.'])
        end
        return
    case 'char'
        op = inline(op);
end

%% Find 'exps' - the exponents in markfuns 
% If op has blow up, we represent it by 
%  (x-ends(1))^exps(1) * (ends(2)-x)^exps(2) * op(x)
% if ~any(isinf(op(ends)))
%     % Nasty hack to avoid looking for exps. To be changed.
%     exps = [0 0];
% else
if isfield(pref,'exps') && ~isempty([pref.exps{:}])
    if numel([pref.exps{:}]) == 2
        exps = [pref.exps{:}];
    elseif ~isempty(pref.exps{1})
        exps(1) = pref.exps{1};
        exps(2) = findexps(op,ends,1);
    else
        exps(1) = findexps(op,ends,-1);
        exps(2) = pref.exps{2};
    end
elseif pref.blowup
    exps = findexps(op,ends);  % Compute exponents
else
    exps = [0 0]; % Standard representation - no blowup
end

if any(exps)
    op = @(x) (x-ends(1)).^exps(1).*(ends(2)-x).^exps(2).*op(x); % new op
end
g.exps = exps;

%% Deal with endpoints involving infinities
if pref.splitting && ~all(isinf(ends)) || any(g.exps)
    
    % Initial setup
    a = ends(1); b = ends(2);
    htol = 1e-14*g.scl.h;
    
    % Get values at the boundary and close to it.
    vne = op([a ; a+htol ; a+2*htol ; b-2*htol ; b-htol ; b]);
       
    if isinf(b) % Only check the left end-point.
        
        % Check for NaN's
        if any(isnan(vne))
            error('CHEBFUN:getfun:naneval','Function returned NaN when evaluated at/near boundary.')
        end
        
        if abs(vne(1)-vne(2))<=10*abs(vne(3)-vne(2))
            va = vne(1);                 % Extrapolation at x=a is not needed
        else
            va = 2*vne(2)-vne(3);        % Extrapolate to the left
        end
        op = @(x) [va;op(x(2:end))];
        
    elseif isinf(a) % Only check the right end-point.
        
        % Check for NaN's
        if any(isnan(vne(6)))
            error('CHEBFUN:getfun:naneval','Function returned NaN when evaluated at/near boundary.')
        end
        
        if abs(vne(6)-vne(5))<=10*abs(vne(4)-vne(5))
            vb = vne(6);                 % Extrapolation at x=b is not needed
        else
            vb = 2*vne(5)-vne(4);        % Extrapolate to the right
        end
        op = @(x) [op(x(1:end-1));vb];
        
    else % In splitting ON mode, decide whether extrapolate values to the boundary
         % (This is needed when the function blows up, i.e. exps~=0).
        
        % Check for NaN's or Inf's
%         if any(isnan(vne)) && ~any(g.exps)
%             error('CHEBFUN:getfun:naneval','Function returned NaN when evaluated at/near boundary.')
%         end
        if any(isinf(vne)) && ~pref.blowup
            error('CHEBFUN:getfun:infeval',['Function returned Inf when evaluated at/near boundary. ', ...
                'Have you tried ''blowup on''']);
        end
        
        if ~isnan(vne(1)) && ~g.exps(1) && abs(vne(1)-vne(2))<=10*abs(vne(3)-vne(2))
            va = vne(1);                 % Extrapolation at x=a is not needed
        else
            va = 2*vne(2)-vne(3);        % Extrapolate to the left
        end
        if ~isnan(vne(1)) && ~g.exps(2) && abs(vne(6)-vne(5))<=10*abs(vne(4)-vne(5))
            vb = vne(6);                 % Extrapolation at x=b is not needed
        else
            vb = 2*vne(5)-vne(4);        % Extrapolate to the right
        end
        op = @(x) [va;op(x(2:end-1));vb];
    end
end

    
%% Call constructor depending on narg
if nargin == 3,
    % non-adaptive case exact number of points provided
    % map might still be adapted for that number of points
    xvals = g.map.for(chebpts(n));
    xvals(1) = g.map.par(1);  xvals(end) = g.map.par(2);
    vals = op(xvals);
    g.vals = vals; g.n = n; g.scl.v = max(g.scl.v, norm(vals,inf));
else
    % adaptive case
    % If map was provided in the chebfun call, overwrite previous assignment.
    if isfield(pref,'map')
        if iscell(pref.map)
            mapfun = str2func(pref.map{1});
            par = g.map.par(1:2);
            if length(pref.map) == 2
                par = [par pref.map{2}(:).'];
            end
            g.map = mapfun(par);
        else
            g.map = pref.map;
        end
    end
    [g,ish] = growfun(op,g,pref);
end


