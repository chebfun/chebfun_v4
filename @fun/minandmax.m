function [y,x] = minandmax(g)
% Minimum and maximum of a fun, i.e. [min(g), max(g)]
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

ends = g.map.par(1:2);
r = roots(diff(g));
r = [ends(1);r;ends(2)];

vals = feval(g,r);
[y(1),idx] = min(vals);
x(1,1) = r(idx);

[y(1,2),idx] = max(vals);
x(1,2) = r(idx);

