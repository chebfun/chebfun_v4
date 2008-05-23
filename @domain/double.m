function e = double(d)
% DOUBLE Convert domain to double.
% DOUBLE(D) returns a vector containing the endpoints and breakpoints (in
% sorted order) of the domain D.
%
% If you want only the endpoints and not any breakpoints, use D(:).

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

e = d.ends;

end