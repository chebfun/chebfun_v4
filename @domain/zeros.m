function Z = zeros(d)
% ZEROS  Zero operator.
% ZEROS(D) returns a chebop representing multiplication by zero for chebfuns 
% defined on the domain D. 
%
% See also CHEBOP.

if isempty(d)
  Z = chebop;
else
  Z = chebop( @zeros, @(u) 0*u, d );
end

end