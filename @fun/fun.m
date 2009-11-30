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
% Additionally, exponents can be pass within PREF by attaching them in a cell
% array to PREF.EXPS, and a non-adaptive call can be forced by setting
% PREF.N to be a positive integer.
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
     pref.n = 0;
else
    pref = varargin{1};
    if ~isa(pref,'struct'), 
        % Non-adaptive case (preferences not needed)
        n = pref;
        pref = chebfunpref;
        pref.n = n;
    elseif isfield(pref,'n')
        % Non-adaptive case (preferences passed)
        n = pref.n;
    else
        % Adaptive case
        pref.n = 0;
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
%         op = inline(op);
        depvar = symvar(op); 
        if numel(depvar) ~= 1, 
            error('Incorrect number of dependent variables in string input'); 
        end
        op = eval(['@(' depvar{:} ')' op]);
end

%% Find 'exps' - the exponents in markfuns 
% If op has blow up, we represent it by 
%  op(x) ./ ( (x-ends(1))^exps(1) * (ends(2)-x)^exps(2) )
% (Note that for blowup exponents are now negative!)
if isfield(pref,'exps') && ~isempty([pref.exps{:}])
    if ~isempty(pref.exps{1}) && ~isempty(pref.exps{2})
        pref.exps
        exps(1) = pref.exps{1};
        exps(2) = pref.exps{2};
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
    rescl = (2/diff(ends))^-sum(exps);
    op = @(x) rescl*op(x)./((x-ends(1)).^exps(1).*(ends(2)-x).^exps(2)); % new op
end
g.exps = exps;
    
%% Call constructor depending on narg
if pref.n
    % non-adaptive case exact number of points provided
    % map might still be adapted for that number of points
    x = chebpts(n,pref.chebkind);
    xvals = g.map.for(x);
    if pref.chebkind == 2
        xvals = adjustends(xvals,g.map.par(1),g.map.par(2));
    end
    vals = op(xvals);
    g.vals = vals; g.n = n; 
    if any(g.exps) || any(isnan(g.vals)) % Extrapolate only in special cases
        g = extrapolate(g,pref,x);
    else
        g.scl.v = max(g.scl.v,norm(vals,inf));
    end
    if pref.chebkind == 1
        % place values back in chebpoints of second kind
        g.vals = chebpolyval(chebpoly(g,1),2);
    end
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