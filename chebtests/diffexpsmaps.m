function pass = diffsingmaps
% Tests the differentiation of chebfuns with maps when there are exponents
% Nick Hale, Dec 2009

tol = 1e4*chebfunpref('eps');

map = {'kte',.99};
map = {'sausage',9};

% left
d = domain([-1,2]);
F = @(x) 1./sqrt(1+x).*sin(x);
f = chebfun(@(x) F(x),d,'exps',[-.5 0],'map',map);
g = diff(f);
f2 = chebfun(F,[-.9 2]);
g2 = diff(f2);
subplot(3,1,1)
plot(g,'b',g2,'--r')
pass(1) = norm(g2-restrict(g,domain(g2)));

% right
d = domain(-2,1);
F = @(x) 1./sqrt(1-x).*sin(x);
f = chebfun(@(x) F(x),d,'exps',[0 -.5],'map',map);
g = diff(f);
f2 = chebfun(F,[-2 .9]);
g2 = diff(f2);
subplot(3,1,2)
plot(g,'b',g2,'--r')
pass(2) = norm(g2-restrict(g,domain(g2)));

% both
d = domain(-2,2);
F = @(x) 1./sqrt(4-x.^2).*sin(x+1);
f = chebfun(@(x) F(x),d,'exps',[-.5 -.5],'map',map);
g = diff(f);
f2 = chebfun(F,[-1.9 1.9]);
g2 = diff(f2);
subplot(3,1,3)
plot(g,'b',g2,'--r')
pass(3) = norm(g2-restrict(g,domain(g2)));

pass = pass < tol;