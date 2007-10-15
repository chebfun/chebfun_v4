function x = cheb(n,a,b)
% This function generates the Chebyshev points.
if n==0, x=1; return, end
if nargin == 1, a = -1; b = 1; end
   
xx = cos(.5*pi*(0:2:2*n)'/n);
x = .5*((b-a)*xx+a+b);
