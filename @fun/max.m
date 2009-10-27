function [out,idx] = max(g)
% MAX	Global maximum on [-1,1]
% MAX(G) is the global maximum of the fun G on [-1,1].
% [Y,X] = MAX(G) returns the value X such that Y = G(X), Y the global maximum.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

if (g.exps(1) < 0 && g.vals(1) >= 0) 
    out = inf; 
    idx = 1;
    return
end

if (g.exps(2) < 0 && g.vals(end) >= 0) 
    out = inf;
    idx = g.n;
    return
end

r = roots(diff(g));
ends = g.map.par(1:2);
r = [ends(1);r;ends(end)];
[out,idx] = max(feval(g,r));
idx = r(idx);