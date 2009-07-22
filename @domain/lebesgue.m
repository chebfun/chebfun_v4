function [L,Lconst] = lebesgue(x,d)  
%  L = LEBESGUE(X), where X is a set of points in [-1,1],
%  returns the Lebesgue function associated with polynomial
%  interpolation in those points.
%
%  L = LEBESGUE(X,D), where D is a domain and X is a set of points
%  in D, returns the Lebesgue function associated with polynomial
%  interpolation in those points in that domain.
%
%  L = LEBESGUE(X,a,b) or LEBESGUE(X,[a,b]) does the same with
%  D = domain(a,b).
%
%  [L,Lconst] = LEBESGUE(X) etc. also returns the Lebesgue constant.
%
%  For example, these commands compare the Lebesgue functions and
%  constants for 8 Chebyshev, Legendre, and equispaced points in [-1,1]:
%
%  n = 8;
%  [L,c] = lebesgue(chebpts(n));
%  subplot(1,3,1), plot(L), title(['Chebyshev: ' num2str(c)])
%  grid on, axis([-1 1 0 8])
%  [L,c] = lebesgue(legpts(n));
%  subplot(1,3,2), plot(L), title(['Legendre: ' num2str(c)])
%  grid on, axis([-1 1 0 8])
%  [L,c] = lebesgue(linspace(-1,1,n));
%  subplot(1,3,3), plot(L), title(['Equispaced: ' num2str(c)])
%  grid on, axis([-1 1 0 8])
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2009 by The Chebfun Team. 
%
%  This version of LEBESGUE lives in @domain.
%  There is a companion code in the chebfun trunk directory.
%
%  Nick Trefethen,  22/07/2009

L = sum(abs(interp1(x,eye(length(x)),d)),2);
if nargout==2, Lconst = norm(L,inf); end
