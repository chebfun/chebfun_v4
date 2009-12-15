function d = mtimes(d,a)
% *      Scale a domain.
% A*D or D*A for domain D and scalar A multiplies all the endpoints and
% breakpoints of D by A.  If A is negative, the ordering of the points is
% then reversed.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

d = times(d,a);

end