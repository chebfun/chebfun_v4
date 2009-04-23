function p = interp1(xk,f)  
%  P = INTERP1(X,F), where X is a vector and F is a chebfun,
%  returns the chebfun P defined on domain(F) corresponding
%  to the polynomial interpolant through F(X(j)) at points X(j).
%
%  P = INTERP1(X,Y,D), where X and Y are vectors and D is a
%  domain, returns the chebfun P defined on D corresponding
%  to the polynomial interpolant through data Y(j) at points X(j).
%
%  For example, these commands plot the interpolant in 11 equispaced
%  points on [-1,1] through a hat function:
%
%  x = chebfun('x');
%  f = max(1,1-2*abs(x));
%  x = linspace(-1,1,11);
%  p = interp1(x,f)
%  hold off, plot(f,'k')
%  hold on, plot(p,'r')
%  grid on, plot(x,f(x),'.r')
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

%  This version of INTERP1 lives in @chebfun.
%  We call @domain/interp1 to do the work:
%
%  Nick Trefethen & Ricardo Pachon,  24/03/2009

yk = feval(f,xk);
p = interp1(xk,yk,domain(f));
