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
if f.ends(1) > mi || f.ends(end) < ma
    error('chebfun:compose:domain','Range of G must be in the domain of F')
end

h = comp(g,@(g) feval(f,g));