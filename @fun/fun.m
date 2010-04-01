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
% FUN(OP,ENDS,PREF,SCL) creates a fun for OP adaptively using the
% preferences provided in the structure PREF (see chebfunpref).  
% Here SCL is a structure with fields SCL.H (horizontal scale) and SCL.V 
% (vertical scale).
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
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team.
%   Last commit: $Author$: $Rev$:
%   $Date$:

persistent default_g
if isnumeric(default_g)                     % Generate an empty fun!
    default_g = struct('vals',[],'n',0,'exps',[0 0]);
    default_g.scl  = struct('h',[],'v',[]);
    default_g.map = struct('for',[],'inv',[],'der',[],'name',[],'par',[]);
    default_g = class(default_g,'fun');
end
g = default_g;
ish = true;                                 % Initialise happiness!

if nargin == 0, return; end                 % Return empty fun
if nargin == 1
    if isa(op,'fun'), g = op; return, end   % Returns the same fun
    error('FUN:fun:ends','Either endpoints or a map must be provided.')
end

% Default preferences
pref = chebfunpref;
pref.n = 0;                                 % Adaptive case by default
if nargin > 2
    if isa(varargin{1},'struct') 
    % Preferences passed
        pref = varargin{1};
        if ~isfield(varargin{1},'n')
            pref.n = 0;                     % Adaptive case
        end
    else
    % Preferences not passed, just n
        pref.n = varargin{1};               % Non-adaptive case
    end
end
% Switch NaNs (for adaptive case) to zeros.
if isnan(pref.n), pref.n = 0; end

%% Deal with endpoints and maps
if ~isnumeric(ends)     
% A map may optionally be passed in the second arg.
    g.map = ends;
    ends = ends.for([-1,1]);
elseif any(isinf(ends))
% The default unbounded map.
    g.map = unbounded(ends);
else
    g.map = linear(ends);
%     The default map (taken from mappref)   
%     mpref = mappref;
%     g.map = maps(fun,{mpref.name,mpref.par},ends);
end

%% Set horizantal scale if not provided
if nargin < 4 || isempty(varargin{2})
    hs = norm(ends,inf);
    if hs == inf,  hs = 2;  end
    g.scl = struct('h',hs,'v',0);
else
    g.scl = varargin{2};
end

%% Deal with input op type
switch class(op)
    case 'fun'      % Returns the same fun
        g = op;
        if nargin > 2
            warning('FUN:constructor:input',['Generating fun from fun on the first' ...
                ' input argument. Other arguments are not used.'])
        end
        return
    case 'double'   % Assigns value to the Chebyshev points
        if min(size(op)) > 1
            error('FUN:constructor:double','Only vector inputs are allowed.')
        end
        if nargin > 2 && pref.n
            warning('FUN:constructor:input',['Generating fun from double object on the first' ...
                ' input argument. Other arguments are not used.'])
        end
        
        if pref.chebkind == 1 
        % Place values back in chebpoints of second kind.   
            g.vals = op(:); g.n = length(op);
            op = chebpolyval(chebpoly(g,1));
        end
        % Assign data to the fun.
        g.vals = op(:); g.n = length(op); g.scl.v = max(g.scl.v, norm(op,inf)); 
        if isfield(pref,'exps') && ~any(isnan(pref.exps)), g.exps = pref.exps; else g.exps = [0 0]; end
        return
    case 'char'
        % Convert string input to anonymous function.
        op = str2op(op);
end

%% Hack for unbounded functions on infinite intervals
infends = isinf(ends);
if any(infends)
    % Remember the op, and define a new one including the unbounded map.
    oldop = op;         op = @(x) op(g.map.for(x));
    if ~isfield(pref,'exps'), 
    % If there aren't any exps, then assign some.
        if pref.blowup, pref.exps = [NaN NaN];
        else            pref.exps = [0 0]; end
    else
    % Exponents on unbounded intervals are negated (from the user's perspective).
        if infends(1),  pref.exps(1) = -pref.exps(1); end
        if infends(2),  pref.exps(2) = -pref.exps(2); end
    end
    % This is a dirty check for functions which appear to blowup at infinity.
    bignums = infends.*[-1 1]*1e10;
    vends = oldop([bignums ends(infends)]);
    if any(isinf(vends)) || any(isnan(vends(1:2))) %|| any(abs(vends) > 1e5)
        pref.blowup = blowup;
        if infends(1) && ~isnan(pref.exps(1)) && ~pref.exps(1)
            pref.exps(1) = NaN;
        end
        if infends(2) && ~isnan(pref.exps(2)) && ~pref.exps(2)
            pref.exps(2) = NaN;
        end
    end   
end

%% Find exponents 
% If op has blow up, we represent it by 
%      op(x) ./ ( (x-ends(1))^exps(1) * (ends(2)-x)^exps(2) )
if isfield(pref,'exps')
    exps = pref.exps;
    if ~pref.blowup, pref.blowup = blowup; end      % The default 'on' option
    if all(isnan(pref.exps))                        % No exps given
        exps = findexps(op,ends,0,pref.blowup);     
    elseif isnan(exps(2))                           % Left exp given
        exps(2) = findexps(op,ends,1,pref.blowup);
    elseif isnan(exps(1))                           % Right exp given 
        exps(1) = findexps(op,ends,-1,pref.blowup);
    end
elseif pref.blowup
    % Blowup flag present. Check for blowup.
    exps = findexps(op,ends,0,pref.blowup);
else
    % Standard representation - No blowup.
    exps = [0 0]; 
end
g.exps = exps;                                      % Assign exponents to fun

% Scaling for funs on bounded intervals with exponents.
if any(exps) && ~any(infends)
    rescl = (2/diff(ends))^-sum(exps);
    op = @(x) rescl*op(x)./((x-ends(1)).^exps(1).*(ends(2)-x).^exps(2)); % New op
end

% Scaling for funs on unbounded domain with exponents.
if any(infends)
    s = g.map.par(3);
    if all(infends),           rescl = .5/(5*s);
    else                       rescl = .5./(15*s);    end
    rescl = rescl.^sum(-exps); op = oldop;
    if any(exps)
        op = @(x) rescl*op(x)./((g.map.inv(x)+1).^exps(1).*(1-g.map.inv(x)).^exps(2)); % New op
    end
end
    
%% Call constructor
if pref.n
    % Non-adaptive case (exact number of points provided).
    x = chebpts(pref.n,pref.chebkind);
    xvals = g.map.for(x);
    g.vals = op(xvals);    g.n = pref.n; 
    if g.n > 2 && (any(g.exps) || any(isnan(g.vals)) || any(isinf(g.map.par([1 2])))) 
    % Extrapolate only in special cases
        g = extrapolate(g,pref,x);
    else
        g.scl.v = max(g.scl.v,norm(g.vals,inf));
    end
    if pref.chebkind == 1
    % Place values back in chebpoints of second kind
        g.vals = chebpolyval(chebpoly(g,1),2);
    end
else
    % Adaptive case
    % If map was provided in the chebfun call then overwrite previous assignment.
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
    % Call growfun to adaptivly construct the fun.
    [g,ish] = growfun(op,g,pref);
end

function op = str2op(op)
% This is here as it's a clean function with no other variables hanging around in the scope.
depvar = symvar(op); 
if numel(depvar) ~= 1, 
    error('CHEBFUN:fun:depvars','Incorrect number of dependent variables in string input.'); 
end
op = eval(['@(' depvar{:} ')' op]);
