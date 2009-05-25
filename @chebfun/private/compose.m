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

ma = max(g); mi = min(g);
if f(1).ends(1) > min(mi) || f(1).ends(end) < max(ma)
    error('chebfun:compose:domain','Range of G must be in the domain of F')
end

if numel(f) == 1
    h = comp(g,@(g) feval(f,g));
elseif numel(f) > 1 && numel(g) == 1
    for k = 1:numel(f)
        h(k) = comp(g,@(g) feval(f(k),g));
    end
elseif size(f) == size(g)
    for k = 1:numel(f)
        h(k) = comp(g(k),@(g) feval(f(k),g));
    end
else
    error('chebfun:compose:dim','Inconsistent quasimatrix dimensions')
end