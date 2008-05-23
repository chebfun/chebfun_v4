function e = end(d,k,m)
% END    Right endpoint of a domain.
% D(END) returns the right endpoint of the domain D. 

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if isempty(d)
  e = 0;
else
  e = 2;
end
