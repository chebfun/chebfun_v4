function pass = tad2

f = chebfun('sin(x)',[0 2*pi]);
g = chebfun('cos(x)',[0 2*pi]);
ip = f'*g;
pass = abs(ip) < eps;

