function out = chebpoly(g)
% CHEBPOLY	Chebyshev polynomial coefficients
% C = CHEBPOLY(G) returns the coefficients such that
% G = C_N T_N(x)+...+C_1 T_1(x)+C_0 T_0(x) where T_N(x) denotes the N-th
% Chebyshev polynomial.

gvals = flipud(g.vals);
n = g.n;
if (n==1), out = gvals; return; end
out = [gvals;gvals(end-1:-1:2)];
out = fft(out)/(2*n-2);
if (isreal(gvals))
  out = real(out);
elseif (isreal(1i*gvals))
  out = 1i*imag(out);
end
out = out(n:-1:1);
if (n > 2), out(2:end-1)=2*out(2:end-1); end
