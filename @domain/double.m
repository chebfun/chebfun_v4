function e = double(d)
% DOUBLE Convert domain to double.
% DOUBLE(D) returns a vector containing the endpoints and breakpoints (in
% sorted order) of the domain D.
%
% If you want only the endpoints and not any breakpoints, use D(:).
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

e = d.ends;

end