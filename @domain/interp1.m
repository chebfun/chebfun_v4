function p = interp1(xk,yk,d)  
%  P = INTERP1(X,F), where X is a vector and F is a chebfun,
%  returns the chebfun P defined on domain(F) corresponding
%  to the polynomial interpolant through F(X(j)) at points X(j).
%
%  P = INTERP1(X,Y,D), where X and Y are vectors and D is a
%  domain, returns the chebfun P defined on D corresponding
%  to the polynomial interpolant through data Y(j) at points X(j).
%
%  For example, these commands plot the interpolant in 11 equispaced
%  points on [-1,1] through a famous function of Runge:
%
%  d = domain(-1,1);
%  ff = @(x) 1./(1+25*x.^2);
%  x = linspace(-1,1,11);
%  f = chebfun(ff,d);
%  p = interp1(x,ff(x),d)
%  hold off, plot(f,'k')
%  hold on, plot(p,'r')
%  grid on, plot(x,p(x),'.r'
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2009 by The Chebfun Team. 
%
%  This version of INTERP1 lives in @domain.
%  There is a companion code in @chebfun.
%
%  Nick Trefethen & Ricardo Pachon,  24/03/2009

w = bary_weights(xk);
a = d.ends;
p = chebfun(@(x) bary(x,yk(:),xk(:),w(:)),a([1 end]),length(xk));
