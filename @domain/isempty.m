function e = isempty(d)
% ISEMPTY Tests for empty interval.
% ISEMPTY(D) returns logical true if the domain D has no specifed interval.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

e = isempty(d.ends);

end