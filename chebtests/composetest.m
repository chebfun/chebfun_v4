function pass = composetest

% Rodrigo Platte, May 2009
% Test composition of two chebfuns (quasimatrices)

% Quasimatrices:
tol = chebfunpref('eps')*10;
x = chebfun('x',[0 1]);
f = chebfun(@sin);
X = [1 x x.^2];
pass(1) =  norm(f(X) - sin(X),inf) < tol;

XX = X(X);
XX2 = [1 x x.^4];
pass(2) =  norm(XX - XX2,inf) < tol;

% Smooth functions
x = chebfun('x');
f = sin(x);
g = chebfun('sin(sin(x))');
pass(3) = norm(f(f) - g) < 10*tol;

% Functions with jumps:
h = chebfun(@(x) sign(x), [-2 0 2], 'splitting',1);
fh = chebfun(@(x) sin(sign(x)), [-2 0 2], 'splitting',1);
pass(4) = norm(f(h) - fh, inf) < tol;


clc
% Function handles;
g = @(x) abs(x);
f = x.^2;
f(g)
pass(5) = norm(f(g) - f, inf) < tol;


