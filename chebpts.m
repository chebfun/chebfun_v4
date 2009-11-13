function [x w] = chebpts(n,d)
%CHEBPTS  Chebyshev points in [-1,1].
%   CHEBPTS(N) returns N Chebyshev points in [-1,1].
%
%   CHEBPTS(N,D) scales the nodes and weights for the domain D. D can be
%   either a domain object or a vector with two components. If the interval
%   is infinite, the map is chosen to be the default 'unbounded map' with
%   mappref('parinf') = [1 0] and mappref('adaptinf') = 0.
%
%   [X W] = CHEBPTS(N,D) returns also a row vector of the (scaled) weights 
%   for Clenshaw-Curtis quadrature.
%   
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if n <= 0, 
    error('CHEBFUN:chebpts:posinpt','Input should be a positive number');
elseif n == 1,
    x = 0; 
    w = 2;
else
    m = n-1;
    x = sin(pi*(-m:2:m)/(2*m))';
    if nargout > 1
        w = weights(n);
    end
end

% rescale x if d is provided:
if nargin > 1
    d = domain(d);
    ab = d.ends;
    dab = diff(ab);
    
    if ~any(isinf(ab))
        % finite interval
        x = (x+1)/2*dab + ab(1);
        w = dab*w/2;
    else
        % infinite interval
        m = maps({'unbounded'},ab); % use default map
        x = m.for(x);
        x([1 end]) = ab([1 end]);
        if nargout > 1
            w = w.*m.der(m.inv(x.'));
        end
        
    end
        
end

function w = weights(n)
% Jörg Waldvogel, "Fast construction of the Fejér and Clenshaw-Curtis 
% quadrature rules", BIT Numerical Mathematics 43 (1), p. 001-018 (2004).
if n == 1
     w = 2;
else
    m = n-1;  
    c = zeros(1,n);
    c(1:2:n) = 2./[1 1-(2:2:m).^2 ]; 
    f = real(ifft([c(1:n) c(m:-1:2)]));
    w = [f(1) 2*f(2:m) f(n)];
end