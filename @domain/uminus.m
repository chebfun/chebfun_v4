function d = uminus(d)
% -     Negate a domain's defining points.
% -D negates the endpoints and breakpoints of D, and reverses their order.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

d.ends = -d.ends(end:-1:1);

end
