function y = polyval(p,x)
% POLYVAL Evaluate polynomial.
% Y = POLYVAL(P,X) returns the value of a polynomial P evaluated at the
% chebfun X. P is a vector of length N+1 whose elements are the
% coefficients of the polynomial in descending powers.
%
%    Y = P(1)*X^N + P(2)*X^(N-1) + ... + P(N)*X + P(N+1)
%
% The polynomial is evaluated at all the points of the chebfun X.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
n = length(p);
y = p(n);
xp = 1;
for i = n-1:-1:1
    xp = xp.*x;
    y = y + p(i)*xp;
end
