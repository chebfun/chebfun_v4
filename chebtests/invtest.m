function pass = invtest

% Nick Hale  07/06/2009
tol = chebfunpref('eps');

x = chebfun('x');
f = sin(x);
g = chebfun(@(x) asin(x), [sin(-1),sin(1)]);
finv = inv(f);
pass1 = norm(g - finv,inf) < 100*tol;

% %  commented for speed
pass2 = true;
% pass2 = norm(f - inv(finv),inf) < 100*tol;

% %  commented for speed
pass3 = true;
% x = chebfun('x',[0,1]);
% f = sqrt(x);
% g = x.^2;
% finv = inv(f,'splitting',true);
% pass3 = norm(g - finv,inf) < 100*tol;

x = chebfun('x');
f = chebfun(@(x) sausagemap(x));
finv = inv(f);
pass4 = norm(f(finv)-x,inf) + norm(finv(f)-x,inf) < 200*tol;

pass = pass1 && pass2 && pass3 && pass4;

function [g,gprime] = sausagemap(s,d)
if nargin<2, d = 9; end % this can be adjusted
c = zeros(1,d+1);
c(d:-2:1) = [1 cumprod(1:2:d-2)./cumprod(2:2:d-1)]./(1:2:d);
c = c/sum(c); g = polyval(c,s);
cp = c(1:d).*(d:-1:1); gprime = polyval(cp,s);


