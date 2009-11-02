function pass = CumsumTest

% Tests cumsum with exponents
% Nick Hale, Nov 2009

tol = chebfunpref('eps');

f = chebfun('1./sqrt(x)',[0 1],'exps',{-.5 -0});
g = chebfun('2*sqrt(x)',[0 1],'exps',{.5 0});
pass(1) = norm(cumsum(f)-g,inf) < 500*tol;

f = chebfun(@(x) sin(x)./sqrt(1-x.^2),'exps',{-.5 -.5});
g = chebfun(@(x) (x.*sin(x)+cos(x).*(1-x.^2))./(1-x.^2).^(3/2),'exps',{-1.5 -1.5});
h = diff(f)-g;
pass(2) = norm(h.vals) < 500*tol;
