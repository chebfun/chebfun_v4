function out = chebpoly(g,kind)
% CHEBPOLY   Chebyshev polynomial coefficients.
% A = CHEBPOLY(F) returns the coefficients such that
% G = A(1) T_N(x) + ... + A(N) T_1(x) + A(N+1) T_0(x) where T_N(x) denotes 
% the N-th Chebyshev polynomial.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
%   Last commit: $Author$: $Rev$:
%   $Date$:


if g.n==1, out = g.vals; return; end
    
if nargin == 1 || kind == 2 % 2nd kind is the default!
    n = g.n;
    gvals = g.vals;
    out = [gvals(end:-1:2) ; gvals(1:end-1)];
    if isreal(gvals)
        out = fft(out)/(2*n-2);
        out = real(out);
    elseif isreal(1i*gvals)
        out = fft(imag(out))/(2*n-2);
        out = 1i*real(out);
    else
        out = fft(out)/(2*n-2);
    end
    out = out(n:-1:1);
    if (n > 2), out(2:end-1)=2*out(2:end-1); end

else % For values from Chebyshev points of the 1st kind
    gvals = g.vals(end:-1:1);
    if isreal(gvals)
        out = realcoefs(gvals);
    elseif (isreal(1i*gvals))
        out = 1i*realcoefs(imag(gvals));
    else
        out = realcoefs(real(gvals))+1i*realcoefs(imag(gvals));
    end
end


function c = realcoefs(v)
% Real case - Chebyshev points of the 1st kind
n = length(v);
w = (2/n)*exp(-1i*(0:n-1)*pi/(2*n)).';
if rem(n,2) == 0 % Even case
    vv = [v(1:2:n-1); v(n:-2:2)];
else % odd case
    vv = [v(1:2:n); v(n-1:-2:2)];
end
c = flipud(real(w.*fft(vv)));
c(end) = c(end)/2;
