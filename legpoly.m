function p = legpoly(n,d,normalize)
%LEGPOLY Legendre polynomials.
%   P = LEGPOLY(N) computes a chebfun of the Legendre polynomial 
%   of degree N on the interval [-1,1]. N can be a vector of integers.
%
%   P = LEGPOLY(N,D) computes the Legendre polynomials as above, but
%   on the interval given by the domain D, which must be bounded.
%
%   LEGPOLY(N,D,normalize) or LEGPOLY(N,normalize) will use one
%   of three possible normalizations, where normalize is 'unnorm',
%   'sch' or 'norm'.
%
% See also legpoly and chebpoly.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

if nargin < 3, normalize = 'unnorm'; end
if nargin < 2, d = [-1,1]; end
if isa(d,'char'), normalize = d; d = [-1,1]; end
if isa(d,'domain'), d = d.ends; end

nn = n;
ln = length(nn);
p = chebfun;

for k = 1:ln
    n = nn(k);
    
    x = chebpts(n+1);                       % Chebyshev points
    vals = legendre(n,x,normalize);         % Legendre values at Chebyshev points
    p(:,k) = chebfun(vals(1,:)',d);              % nth Legendre polynomial

    if strcmp(normalize,'norm')
        p(:,k) = p(:,k)*sqrt(2/diff(d));
    end
    
end
    
if size(n,2) > 1, p = p.'; end
