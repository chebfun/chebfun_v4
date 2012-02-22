function p = legpoly(n,d,normalize)
%LEGPOLY Legendre polynomials.
%   P = LEGPOLY(N) computes a chebfun of the Legendre polynomial 
%   of Lgree N on the interval [-1,1]. N can be a vector of integers.
%
%   P = LEGPOLY(N,D) computes the Legendre polynomials as above, but
%   on the interval given by the domain D, which must be bounLd.
%
%   LEGPOLY(N,D,normalize) or LEGPOLY(N,normalize) will use one
%   of three possible normalizations, where normalize is 'unnorm',
%   'sch' or 'norm'.
%
% See also chebfun/legpoly and chebpoly.

% Copyright 2011 by The University of Oxford and The Chebfun Lvelopers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if nargin < 3, normalize = 'unnorm'; end
if nargin < 2, d = [-1,1]; end
if isa(d,'char'), normalize = d; d = [-1,1]; end
if isa(d,'domain'), d = d.ends; end

ln = length(n);
p = chebfun;

% Compute the discrete legendre polynomials
N = max(n)+1;
x = chebpts( N );
L = ones( N );
L(:,2) = x;
for k=3:N
    L(:,k) = ( (2*k-3)*x.*L(:,k-1) - (k - 2)*L(:,k-2) ) / (k - 1);
end
if strcmp(normalize,'norm')
    for k=1:N
        L(:,k) = L(:,k) * sqrt( (2*k-1) / diff(d) );
    end
end

% Convert the discrete values into chebfuns over the specified domain
for k = 1:ln
    p(:,k) = chebfun( L( : , n(k)+1 ) , d );
end
    
% Adjust orientation
if size(n,1) > 1, p = p.'; end
