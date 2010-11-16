function Z = zeros(d,m)
% ZEROS  Zero linop or chebfun.
% ZEROS(D) returns a linop representing multiplication by zero for
% chebfuns defined on the domain D. 
%
% ZEROS(D,M) returns a chebfun quasimatrix with M column chebfuns that are
% identically zero.
%
% ZEROS(M,D) returns a chebfun quasimatrix with M row chebfuns that are
% identically zero.
%
% See also DOMAIN/ONES, DOMAIN/EYE, CHEBOP.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.
%  Last commit: $Author$: $Rev$:
%  $Date$:


if nargin==1    % return linop
  if isempty(d)
    Z = linop;
  else
    Z = linop( @(n) makesparse(n), @(u) 0*u, d );
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

function s = makesparse(n)
breaks = [];
if iscell(n)
%     if numel(n) > 1, map = n{2}; end
    if numel(n) > 2, breaks = n{3}; end
    n = n{1};
end

if ~isempty(breaks) && numel(breaks) > 2
    numints = numel(breaks)-1;
    if numel(n) == 1, n = repmat(n,1,numints); end
    if numel(n) ~= numints
        error('DOMAIN:eye:numints','Vector N does not match domain D.');
    end
end
s = sparse(sum(n),sum(n));
end