function h = compose(f,g)
% COMPOSE chebfun composition
%   COMPOSE(F,G) returns the composition of the chebfuns F and G, F(G). The
%   range of G must be in the domain of F.
%
%   Example: 
%           f = chebfun(@(x) 1./(1+100*x.^2));
%           g = chebfun(@(x) asin(.99*x)/asin(.99));
%           h = compose(f,g);
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team. 
%   Last commit: $Author$: $Rev$:
%   $Date$:

if f(1).trans ~= g(1).trans
    error('chebfun:compose:dim','Inconsistent quasimatrix dimensions');
end

if numel(f) == 1
    for k = 1:numel(g)
        h(k) = composecol(f,g(k));
    end
elseif numel(g) == 1
    for k = 1:numel(f)
        h(k) = composecol(f(k),g);
    end
elseif size(f) == size(g)
    for k = 1:numel(f)
        h(k) = composecol(f(k),g(k));
    end
else
    error('chebfun:compose:dim','Inconsistent quasimatrix dimensions')
end


function h  = composecol(f,g)
% Composition of two column chebfuns.

% Use vertical orientation
trans = f.trans; f.trans = false; g.trans = false;

% Delta functions ?
if size(f.imps,1) > 1 || size(g.imps,1) >1
    warning('chebfun:compose:imps', 'Compoistion does not handle delta functions')
end

% g must be a real-valued function
if ~isreal(g)
    error('chebfun:compose:complex', 'G must be real valued to construct F(G)')
end

tol = 100*chebfunpref('eps');

% Range of g must be in the domain of f.
ma = max(g); mi = min(g);
if f.ends(1) > min(mi)+tol || f.ends(end) < max(ma) - tol
    error('chebfun:compose:domain','F(G): range of G must be in the domain of F')
end

% If f has breakpoints, find the correspoing x-points in the domain of g.
bkpts = [];
if f.nfuns >1
    bkf = f.ends(f.ends > min(mi)+tol & f.ends < max(ma)-tol);
    for k = 1:length(bkf)
        bkpts = [bkpts; roots(g-bkf(k))];
    end
end
ends = union(g.ends, bkpts);

% Construct the chebfun of the composition using horizontal concatenation
h = chebfun;
for k = 1:length(ends)-1
    g1 = restrict(g,ends(k:k+1));
    %vals = g1.funs.vals; a = max(vals); b = min(vals);
    %g1.funs.vals = (1-1e-12)*(vals-(a+b)/2)+(a+b)/2;
    h = [h; comp(g1,@(g) feval(f,g))];
end

% Fix orientation
h.trans = trans;

% Fix imps values
h.imps(1,:) = feval(f, feval(g,h.ends));
