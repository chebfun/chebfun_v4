function x = cheb(n)
% This function generates the Chebyshev points.
if n==0, x=1; return, end
x=sin(pi*(n:-2:-n)/(2*n))';