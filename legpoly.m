function p = legpoly(n,d,normalize)
%LEGPOLY Legendre polynomials.
%   P = LEGPOLY(N) computes a chebfun of the Legendre polynomial 
%   of degree N on the interval [-1,1]. N must be a scalar integer.
%
%   P = LEGPOLY(N,D) computes the Legendre polynomial as above, but
%   on the interval given by the domain D, which must be bounded.
%
%   LEGPOLY(N,D,normalize) or LEGPOLY(N,normalize) will use one
%   of three possible normalizations, where normalize is 'unnorm',
%   'sch' or 'norm'.
%
% See also chebfun/legpoly and chebpoly.

if nargin < 3, normalize = 'unnorm'; end
if nargin < 2, d = [-1,1]; end
if isa(d,'char'), normalize = d; d = [-1,1]; end
if isa(d,'domain'), d = d.ends; end

x = chebpts(n+1);                       % Chebyshev points
vals = legendre(n,x,normalize);         % Legendre values at Chebyshev points
p = chebfun(vals(1,:)',d);              % nth Legendre polynomial

if strcmp(normalize,'norm')
    p = p*sqrt(2/diff(d));
end