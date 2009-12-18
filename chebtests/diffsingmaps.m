function pass = diffsingmaps
% Tests the differentiation of chebfuns with singmaps when there are exponents
% Nick Hale & Rodrigo Platte, Dec 2009

tol = max(4e-8,100*chebfunpref('eps'));

% left
d = domain([-1,2]);
F = @(x) sqrt(1+x)+sin(x);
f = chebfun(@(x) F(x),d,'singmap',[.5 1]);
g = diff(f);
h = diff(g);
f2 = chebfun(F,[-.9 2]);
g2 = diff(f2);
h2 = diff(g2);
% figure
% subplot(2,1,1)
% plot(g,'b',g2,'--r')
% subplot(2,1,2)
% plot(h,'b',h2,'--r')
pass(1) = norm(g2-restrict(g,domain(g2)));
pass(2) = norm(h2-restrict(h,domain(h2)));

% right
d = domain(-2,1);
F = @(x) sqrt(1-x)+sin(x);
f = chebfun(@(x) F(x),d,'singmap',[1 .5]);
g = diff(f);
h = diff(g);
f2 = chebfun(F,[-2 .9]);
g2 = diff(f2);
h2 = diff(g2);
% figure
% subplot(2,1,1)
% plot(g,'b',g2,'--r')
% subplot(2,1,2)
plot(h,'b',h2,'--r')
pass(3) = norm(g2-restrict(g,domain(g2)));
pass(4) = norm(h2-restrict(h,domain(h2)));

% both
d = domain(-2,2);
F = @(x) sqrt(4-x.^2)+sin(x+1);
f = chebfun(@(x) F(x),d,'singmap',[.5 .5]);
g = diff(f);
h = diff(g);
f2 = chebfun(F,[-1.9 1.9]);
g2 = diff(f2);
h2 = diff(g2);
% figure
% subplot(2,1,1)
% plot(g,'b',g2,'--r')
% subplot(2,1,2)
% plot(h,'b',h2,'--r')
pass(5) = norm(g2-restrict(g,domain(g2)));
pass(6) = norm(h2-restrict(h,domain(h2)));

pass = pass < tol;