function out = chebpoly(n,ends)
% CHEBPOLY	Chebyshev polynomial
%    F = CHEBPOLY(N) returns a chebfun F equal to the Chebyshev
%    polynomial T_N on [-1,1].  F = CHEBPOLY(N,ends) returns
%    T_N scaled to the interval [ends(1),ends(2)].

% Nick Trefethen, 2007, Chebfun Version 2.0

f = fun([1 zeros(1,n)]);
if nargin==1
   ends = [-1 1];
end
out = chebfun(f,ends);
