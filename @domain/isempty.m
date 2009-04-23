function e = isempty(d)
% ISEMPTY Tests for empty interval.
% ISEMPTY(D) returns logical true if the domain D has no specifed interval.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

e = isempty(d.ends);

end