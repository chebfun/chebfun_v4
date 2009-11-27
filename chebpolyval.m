function v = chebpolyval(c,kind)
%CHEBPOLYVAL   maps Chebyshev coefficients to values at Chebyshev points
%   CHEBPOLYVAL(C) returns the values of the polynomial 
%   P(x) = C(1)T_{N-1}(x)+C(2)T_{N-2}(x)+...+C(N) at Chebyshev nodes.
%               
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

c = c(:);       % input should be a column vector
lc = length(c);
if lc == 1, v = c; return; end

% 2nd kind Chebyshev points
if nargin == 1 || kind == 2
    ii = 2:lc-1;
    c(ii) = c(ii)/2;
    v = [(c(end:-1:1)); c(ii)];
    if isreal(c)
        v=real(ifft(v));
    elseif isreal(1i*c)
        v=1i*real(ifft(imag(v)));
    else
        v=ifft(v);
    end
    v = (lc-1)*[2*v(1); (v(ii)+v(2*lc-ii)); 2*v(lc)];
    v=flipud(v);
    
else % 1st kind
    if isreal(c)
        v = realvals(c);
    elseif isreal(1i*c)
        v = 1i*realvals(imag(c));
    else
        v = realvals(real(c))+1i*realvals(imag(c));
    end
end

function c = realvals(c)
% Real case - Chebyshev points of the 1st kind

c = flipud(c); n = length(c);
w = n*exp(1i*(0:n-1)*pi/(2*n)).';
c = w.*c;
vv = real(ifft(c));
if rem(n,2) == 0 % Even case
    c(1:2:n-1) = vv(1:n/2);
    c(n:-2:2) = vv(n/2+1:n);
else % odd case
    c(1:2:n) = vv(1:(n+1)/2);
    c(n-1:-2:2) = vv((n+1)/2+1:n);
end
c = flipud(c);