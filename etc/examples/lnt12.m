% lnt12.m  evaluate erf(z) for complex z  12.06
%   Here's how it works: the chebfun system finds
%   a Chebyshev expansion for erf(z) on [-5,5];
%   we then simply evaluate this expansion at
%   complex values near [-2,2].  As a check we
%   look at the value erf(i).

% First we compure erf in the complex plane and plot it:
 f = chebfun(@(x) erf(x),[-5 5]);
 x = linspace(-2,2,100); y = linspace(-1,1,50);
 [xx,yy] = meshgrid(x,y);
 zz = xx + 1i*yy;
 contour(x,y,abs(f(zz))), colorbar;
% Now we compare our complex erf with the "exact" one at z=i:
 f(1i)
 exact = (2i/sqrt(pi))*sum(chebfun(@(t) exp(-(1i*t).^2),[0 1]))