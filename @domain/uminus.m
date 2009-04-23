function d = uminus(d)
% -     Negate a domain's defining points.
% -D negates the endpoints and breakpoints of D, and reverses their order.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

d.ends = -d.ends(end:-1:1);

end
