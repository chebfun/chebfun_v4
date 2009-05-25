function pass = composetest

% Rodrigo Platte, May 2009
% Test composition of two chebfuns (quasimatrices)

tol = chebfunpref('eps')*10;
x = chebfun('x',[0 1]);
f = chebfun(@sin);
X = [1 x x.^2];
pass =  norm(f(X) - sin(X),inf) < tol;