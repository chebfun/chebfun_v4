function pass = dummy2
% Intended to fail!

f = chebfun('sin(x)',[0 2*pi]);
g = chebfun('cos(x)',[0 2*pi]);
ip = f'*g;
pass = abs(ip-1) < eps;

