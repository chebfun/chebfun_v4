function I = eye(d)
% EYE Identity operator.
% EYE(D) returns a chebop representing the identity for functions defined 
% on the domain D.
%
% See also CHEBOP.

if isempty(d)
  I = chebop;
else
  I = chebop( @speye, @(u) u, d );
end

end