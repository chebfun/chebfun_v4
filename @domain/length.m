function l = length(d)
% LENGTH  Length of a domain's interval.
% LENGTH(D) returns the difference between endpoints, D(end)-D(1).

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if isempty(d)
  l = 0;
else
  l = d.ends(end)-d.ends(1);
end

end