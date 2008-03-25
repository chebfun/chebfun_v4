function f = chebeval(p,x)
%CHEBEVAL Evaluate a Chebyshev expansion at any points.
%   CHEBEVAL(p,x) evaluates the Chebyshev expansion 
%
%      p(1)T_0(x) + p(2)T_1(x) + ... + p(n)T_[n-1](x)
%	
%   at the given points x.

f = zeros(size(x));
x = x(:);
p = p(:);
N = length(p)-1;
m = length(x);

T = cos( acos(x) * (0:N) );
f(:) = T*p;
