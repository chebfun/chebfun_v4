function pass = outerprod

% Toby Driscoll
% Outer product testing

tol = chebfunpref('eps');

[d,x] = domain(0,1);
f = [ exp(x), tanh(x) ];
g = [ exp(x), x./(1+x.^2) ];
u = x;

A = f*g';
Au = (exp(x) + (1-pi/4)*tanh(x));

% operational form
pass(1) = norm( Au - A*u ) < 1e-12*(tol/eps);

% discrete form
xx = (1+sin(pi*(2*(1:200)'-200-1)/(400-2)))/2;
pass(2) = norm( Au(xx) - A(200)*u(xx) ) < 1e-12*(tol/eps);

