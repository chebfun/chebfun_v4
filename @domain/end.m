function e = end(d,k,m)
% END    Right endpoint of a domain.
% D(END) returns the right endpoint of the domain D. 
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if isempty(d)
  e = 0;
else
  e = 2;
end
