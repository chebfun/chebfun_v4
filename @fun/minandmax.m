function [y,x] = minandmax(g)
% Minimum and maximum of a fun, i.e. [min(g), max(g)]
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

x = [0 0]; y = [0 0];

if g.exps(2)
    if g.vals(end) >= 0, 
        y(2) = inf;   x(2) = g.n;
    else
        y(1) = -inf;  x(1) = g.n;
    end
end

if g.exps(1)
    if g.vals(1) >= 0,
        y(2) = inf;    x(2) = 1;
    else
        y(1) = -inf;   x(1) = 1;
    end
end

if all(isinf(y)), return, end

ends = g.map.par(1:2);
r = roots(diff(g));
r = [ends(1);r;ends(2)];
vals = feval(g,r);

if ~isinf(y(1))
    [y(1),idx] = min(vals);
    x(1,1) = r(idx);
end

if ~isinf(y(2))
    [y(1,2),idx] = max(vals);
    x(1,2) = r(idx);
end
