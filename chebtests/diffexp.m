function pass = diffexp
% Sheehan Olver
tol = chebfunpref('eps');

f = chebfun('exp(x)',[-sqrt(7),pi]);
pass(1) = norm(f-diff(f),inf) < 1000*tol;

f = chebfun('exp(x)',[-inf,0]);
pass(2) = norm(f-diff(f),inf) < 1000*tol;

f = chebfun('exp(-x)',[0,inf]);
pass(3) = norm(f+diff(f),inf) < 1000*tol;
