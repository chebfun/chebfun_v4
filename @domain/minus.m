function d = minus(d,a)
% -      Translate a domain to the left.
% D-A for domain D and scalar A subtracts A from all of the domain D's
% endpoints and breakpoints.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

d = plus(d,-a);

end