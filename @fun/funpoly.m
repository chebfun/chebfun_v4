function V = funpoly(v)
% CHEBPOLY	Chebyshev polynomial coefficients
% A = CHEBPOLY(F) returns the coefficients such that
% F = a_N T_N(x)+...+a_1 T_1(x)+a_0 T_0(x) where T_N(x) denotes the N-th
% Chebyshev polynomial.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
fn=v.val;
n=v.n;
if (n==0), V=fn.'; return; end
V=[fn;fn(end-1:-1:2,:)];
if (isreal(V))
  V = real(fft(V))/(2*n);
elseif (isreal(1i*V))
  V = 1i*imag(fft(V))/(2*n);
else
  V = fft(V)/(2*n);
end
V=(V(n+1:-1:1,:));
if (n>1), V(2:end-1,:)=2*V(2:end-1,:); end
V=V.';
