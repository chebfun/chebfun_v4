function I = eye(d)
% EYE Identity operator.
% EYE(D) returns a chebop representing the identity for functions defined 
% on the domain D.
%
% See also chebop, linop.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

%  Last commit: $Author$: $Rev$:
%  $Date$:

if isempty(d)
  I = linop;
else
  I = linop( @speye, @(u) u, d );
end

end