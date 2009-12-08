function [x w] = chebpts(n,d,kind)
%CHEBPTS  Chebyshev points in [-1,1].
%   CHEBPTS(N) returns N Chebyshev points of the second kind in [-1,1].
%
%   CHEBPTS(N,D) scales the nodes and weights for the domain D. D can be
%   either a domain object or a vector with two components. If the interval
%   is infinite, the map is chosen to be the default 'unbounded map' with
%   mappref('parinf') = [1 0] and mappref('adaptinf') = 0.
%
%   [X W] = CHEBPTS(N,D) returns also a row vector of the (scaled) weights 
%   for Clenshaw-Curtis quadrature.
%
%   CHEBPTS(N,KIND) or CHEBPTS(N,D,KIND) returns Chebysehv points of the
%   first kind if KIND = 1 and second kind if KIND = 2 (default). 
%
%   See also legpts and jacpts.
%   
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

scale = false;
if nargin == 1
    kind = 2;
elseif nargin==2
    if isa(d,'domain')
       d = domain(d);
       d = d.ends;
       scale = true;
       kind = 2;
    elseif length(d) == 2
       scale = true;
       kind = 2; 
    else
        kind = d;
    end
elseif nargin == 3
    scale = true; 
    if isa(d,'domain')
        d = domain(d);
        d = d.ends;   
    end
end

if      strcmpi(kind,'1st'), kind = 1;
elseif  strcmpi(kind,'2nd'), kind = 2; end
        
w = 2;
if n <= 0, 
    error('CHEBFUN:chebpts:posinpt','Input should be a positive number');
elseif n == 1,
    x = 0; 
else
    m = n-1;
    if kind == 1
        x = sin(pi*(-m:2:m)/(2*m+2)).';
        if nargout > 1
            w = weights1(n);
        end
    else
        x = sin(pi*(-m:2:m)/(2*m)).';
        if nargout > 1
            w = weights2(n);
        end
    end
end

% rescale x if d is provided:
if scale
    dab = diff(d);
    
    if ~any(isinf(d))
        % finite interval
        x = x/2*dab + (d(1) + dab/2);
        w = dab*w/2;
    else
        % infinite interval
        m = maps({'unbounded'},d); % use default map
        if nargout > 1
            w = w.*m.der(x.');
        end
        x = m.for(x);
        x([1 end]) = d([1 end]);
        
    end
        
end

function w = weights2(n) % 2nd kind
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

function w = weights1(n) % 1st kind
% Jörg Waldvogel, "Fast construction of the Fejér and Clenshaw-Curtis
% quadrature rules", BIT Numerical Mathematics 43 (1), p. 001-018 (2004).
if n == 1
    w = 2;
else
    l = floor(n/2)+1;
    K = 0:n-l;   
    v = [2*exp(1i*pi*K/n)./(1-4*K.^2)  zeros(1,l)];
    w = real(ifft(v(1:n) + conj(v(n+1:-1:2))));
end
