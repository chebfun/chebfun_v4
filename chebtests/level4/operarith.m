function pass = operarith
% This test is checking basic arithmetric operations of linear and non-linear
% chebops. 

d = domain(-1,4);
Q = cumsum(d);
D = diff(d);
f = chebfun(@(x) exp(sin(x).^2+2),d);
F = diag(f);
A = -(2*D^2 - F*Q + 3);
Af = A*f;

pass = norm( Af - (f.*cumsum(f)-2*diff(f,2)-3*f) ) < 1e4*eps;