function pass = interp1test

% Nick Trefethen March 2009

d = domain(-2,1.5);
ff = @(x) 1./(1+25*x.^2);
x = linspace(-2,1.5,11);
f = chebfun(ff,d);
p = interp1(x,ff(x),d);
pass1 = (abs(min(p)-(-2.439))<0.01);

x = chebfun('x');
f = max(0,1-2*abs(x-.2));
xk = [0 .5 1];
p = interp1(xk,f);
pass2 = (abs(p(-1)-0.4)<0.01);

pass = pass1 && pass2;
