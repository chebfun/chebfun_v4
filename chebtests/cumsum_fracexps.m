function pass = cumsum_fracexps

tol = 1e2*chebfunpref('eps');
tol2 = 1e5*chebfunpref('eps');
tol3 = 1e8*chebfunpref('eps');

a = -.99; b = .99;
xx = linspace(a,b,100);

fcn = 'sin(2*pi*x)';
dotest = 0; % Set this to 1 if you're testing these 

%%
f = chebfun([fcn '.*(1+x).^.1.*(1-x).^3'],'exps',[.1 0]);
g = cumsum(f);
h = cumsum(f{a,b})+g(a);
if dotest
    clc, display(f), display(g),plot(g,'b',h,'.r');
end
err(1) = norm(g(xx) - h(xx),inf);
pass(1) = err(1)< tol;

%%
f = chebfun([fcn '.*(1+x).^-.1.*(1-x).^3'],'exps',[-.1 0]);
g = cumsum(f);
h = cumsum(f{a,b})+g(a);
if dotest
    clc, display(f), display(g),plot(g,'b',h,'.r');
end
err(2) = norm(g(xx) - h(xx),inf);
pass(2) = err(2)< tol;

%%
f = chebfun([fcn '.*(1+x).^1.*(1-x).^.5'],'exps',[0 .5]);
g = cumsum(f);
h = cumsum(f{a,b})+g(a);
if dotest
    clc, display(f), display(g),plot(g,'b',h,'.r');
end
err(3) = norm(g(xx) - h(xx),inf);
pass(3) = err(3)< tol;

%%
f = chebfun([fcn '.*(1+x).^1.*(1-x).^-.5'],'exps',[0 -.5]);
g = cumsum(f);
h = cumsum(f{a,b})+g(a);
if dotest
    clc, display(f), display(g),plot(g,'b',h,'.r');
end
err(4) = norm(g(xx) - h(xx),inf);
pass(4) = err(4)< tol;

%%
f = chebfun([fcn '.*(1+x).^.3.*(1-x).^.5'],'exps',[.3 .5]);
g = cumsum(f);
h = cumsum(f{a,b})+g(a);
if dotest
    clc, display(f), display(g),plot(g,'b',h,'.r');
end
err(5) = norm(g(xx) - h(xx),inf);
pass(5) = err(5)< tol;

%%
f = chebfun([fcn '.*(1+x).^.3.*(1-x).^-.5'],'exps',[.3 -.5]);
g = cumsum(f);
h = cumsum(f{a,b})+g(a);
if dotest
    clc, display(f), display(g),plot(g,'b',h,'.r');
end
err(6) = norm(g(xx) - h(xx),inf);
pass(6) = err(6)< tol2;

%%
f = chebfun([fcn '.*(1+x).^-.3.*(1-x).^.5'],'exps',[-.3 .5]);
g = cumsum(f);
h = cumsum(f{a,b})+g(a);
if dotest
    clc, display(f), display(g),plot(g,'b',h,'.r');
end
err(7) = norm(g(xx) - h(xx),inf);
pass(7) = err(7)< tol2;

%%
f = chebfun([fcn '.*(1+x).^-.3.*(1-x).^-.5'],'exps',[-.3 -.5]);
g = cumsum(f);
h = cumsum(f{a,b})+g(a);
if dotest
    clc, display(f), display(g),plot(g,'b',h,'.r');
end
err(8) = norm(g(xx) - h(xx),inf);
pass(8) = err(8)< tol3;

