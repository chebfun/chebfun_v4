function [y,x] = range(g)
% Range of a fun, i.e. [min(g), max(g)]
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:
% Copyright 2002-2008 by The Chebfun Team. 

r = roots(diff(g));
r = [-1;r;1];

[y(1),idx] = min(bary(r,g.vals));
x(1) = r(idx);

[y(1,2),idx] = max(bary(r,g.vals));
x(1,2) = r(idx);

