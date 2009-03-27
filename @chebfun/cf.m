function [p,lam] = cf(f,m)
%
% P = CF(F,M): degree M polynomial CF approximant to chebfun F
%              (which must consist of just a single fun)
%
% [P,LAMBDA] = CF(F,M): same plus LAMBDA, the associated CF
%           singular value, an approximation to the minimax error
%
% Example:
%   f = chebfun('sin(20*exp(x))');
%   p = cf(f,40);
%   plot(f-p)
%
% CF = Caratheodory-Fejer approximation is a near-best approximation
% that is often indistinguishable from the true best approximation
% as computed by REMEZ(F,M), but often much faster to compute. 
% See M. H. Gutknecht and L. N. Trefethen, "Real polynomial Chebyshev
% approximation by the Caratheodory-Fejer method", SIAM J. Numer.
% Anal. 19 (1982), 358-371.
%
% Note: at present this is restricted to [-1,1] and to
%       polynomial CF approximation only

M = length(f)-1;                         % degree of f
if m>=M
   p = f;
   return
end
a = chebpoly(f);
if m==M-1
   p = chebfun(chebpolyval(a(2:M+1))); 
   return
end
c = a(M-m:-1:1);
[V,D] = eig(hankel(c));
[lam,i] = max(abs(diag(D)));
u = V(:,i);
u1 = u(1); uu = u(2:M-m);
b = c; 
for k = m:-1:-m 
   b = [-(b(1:M-m-1)*uu)/u1 b];
end
d = a(M-m+1:M+1) - [b(1:m) 0] - b(2*m+1:-1:m+1);
p = chebfun(chebpolyval(d));
