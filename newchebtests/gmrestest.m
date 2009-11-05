function pass = gmrestest
% Sheehan Olver

tol = chebfunpref('eps');

[d x] = domain(-1,1);
f = exp(x);
w = 100;
D = diff(d);
L = D + 1i*w;
u = gmres(L,f);
pass = abs(sum(f.*exp(1i.*w.*x))-(u(1).*exp(1i.*w)-u(-1).*exp(-1i.*w))) < 10*tol;

