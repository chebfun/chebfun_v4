function I = eye(d)
% EYE Identity operator.
% EYE(D) returns a chebop representing the identity for functions defined 
% on the domain D.
%
% See also CHEBOP.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if isempty(d)
  I = chebop;
else
  I = chebop( @speye, @(u) u, d );
end

end