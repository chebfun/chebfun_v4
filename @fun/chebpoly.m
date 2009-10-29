function out = chebpoly(g)
% CHEBPOLY   Chebyshev polynomial coefficients.
% A = CHEBPOLY(F) returns the coefficients such that
% G = A(1) T_N(x) + ... + A(N) T_1(x) + A(N+1) T_0(x) where T_N(x) denotes 
% the N-th Chebyshev polynomial.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
%   Last commit: $Author$: $Rev$:
%   $Date$:

gvals = flipud(g.vals);
n = g.n;
if (n==1), out = gvals; return; end
out = [gvals;gvals(end-1:-1:2)];

if (isreal(gvals))
  out = fft(out)/(2*n-2); 
  out = real(out);
elseif (isreal(1i*gvals))
  out = fft(imag(out))/(2*n-2);   
  out = 1i*real(out);
else
  out = fft(out)/(2*n-2);  
end
out = out(n:-1:1);
if (n > 2), out(2:end-1)=2*out(2:end-1); end
