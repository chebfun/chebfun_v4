function d = minus(d,a)
% -      Translate a domain to the left.
% D-A for domain D and scalar A subtracts A from all of the domain D's
% endpoints and breakpoints.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

d = plus(d,-a);

end