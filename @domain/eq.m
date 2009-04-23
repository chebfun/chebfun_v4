function e = eq(a,b)
% ==     Equality of domains
% Domains are considered equal if their endpoints are identical floating
% point numbers. Breakpoints are not considered.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if isempty(a) || isempty(b)
  e = [];
else
  e = isequal( a.ends([1 end]), b.ends([1 end]) );
end

end