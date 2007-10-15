function x = domain(a,b)

x = chebfun('x',[a b]);
x = (1-x)*a/2 + (x+1)*b/2;
