function S = ones(d,m)
% ONES  Unit chebfun.
% ONES(D,M) returns a chebfun quasimatrix with M column chebfuns that are
% identically one.
%
% ONES(M,D) returns a chebfun quasimatrix with M row chebfuns that are
% identically zero.
%
% See also DOMAIN/ZEROS, DOMAIN/EYE.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if isnumeric(d) % number given first
  s = chebfun(1,m);
  S = repmat(s.',d,1);
else
  s = chebfun(1,d);
  S = repmat(s,1,m);
end

end