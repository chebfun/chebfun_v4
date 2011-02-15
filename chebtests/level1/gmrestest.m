function pass = gmrestest
% Test the Chebfun implementation of GMRES for solving Lu = f, 
% where L is an operator, and both f and u are chebfuns

% Sheehan Olver

tol = chebfunpref('eps');

[d x] = domain(-1,1);
f = exp(x);
w = 100;
D = diff(d);
L = D + 1i*w;
[u,flag] = gmres(L,f);
pass(1) = ~flag;
pass(2) = abs(sum(f.*exp(1i.*w.*x))-(u(1).*exp(1i.*w)-u(-1).*exp(-1i.*w))) < 10*tol;

