function pass = restrictscl

% RodP Jan 09
% This function tests the retrict function (problem related to a bug report
% by Justin Kao of MIT.

tol = chebfunpref('eps');

f = chebfun(@(x)x,[0 1]);
g = f{0.5,1};
pass = g.^-2 == (g.^-1./g) && g.scl == 1 && norm(g.imps - [0.5 1],inf)<tol;