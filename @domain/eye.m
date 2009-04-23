function I = eye(d)
% EYE Identity operator.
% EYE(D) returns a chebop representing the identity for functions defined 
% on the domain D.
%
% See also CHEBOP.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if isempty(d)
  I = chebop;
else
  I = chebop( @speye, @(u) u, d );
end

end