function Z = zeros(d,m)
% ZEROS  Zero chebop or chebfun.
% ZEROS(D) returns a chebop representing multiplication by zero for
% chebfuns defined on the domain D. 
%
% ZEROS(D,M) returns a chebfun quasimatrix with M column chebfuns that are
% identically zero.
%
% ZEROS(M,D) returns a chebfun quasimatrix with M row chebfuns that are
% identically zero.
%
% See also DOMAIN/ONES, DOMAIN/EYE, CHEBOP.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if nargin==1    % return chebop
  if isempty(d)
    Z = chebop;
  else
    Z = chebop( @(n) sparse(n,n), @(u) 0*u, d );
  end
else            % return chebfun
  if isnumeric(d) % number given first
    z = chebfun(0,m);
    Z = repmat(z.',d,1);
  else
    z = chebfun(0,d);
    Z = repmat(z,1,m);
  end
end

end