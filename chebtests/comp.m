function pass = comp

% Tests elementary functions of chebfuns.
% Rodrigo Platte, May 2009

tol = chebfunpref('eps');

f = chebfun(@(x) exp(-x), [0 inf]);
f2 = chebfun(@(x) sin(exp(-x)), [0 inf]);
f3 = sin(f);
pass(1) = norm(f2-f3,inf) < tol*100;

f2 = chebfun(@(x) cos(exp(-x)), [0 inf]);
f3 = cos(f);
pass(2) = norm(f2-f3,inf) < tol*100;