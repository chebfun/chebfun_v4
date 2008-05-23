function Z = zeros(d)
% ZEROS  Zero operator.
% ZEROS(D) returns a chebop representing multiplication by zero for chebfuns 
% defined on the domain D. 
%
% See also CHEBOP.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if isempty(d)
  Z = chebop;
else
  Z = chebop( @zeros, @(u) 0*u, d );
end

end