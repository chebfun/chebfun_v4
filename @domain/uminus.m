function d = uminus(d)
% -     Negate a domain's defining points.
% -D negates the endpoints and breakpoints of D, and reverses their order.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

d.ends = -d.ends(end:-1:1);

end
