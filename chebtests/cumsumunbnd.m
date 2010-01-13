function pass = cumsumunbnd
% Test cumsum with exps < 1. 
% This is still experimental, so the tolerance is REALLY high.
%
% Nick Hale, Dec 2009

chebfunpref('factory');
tol = 2e-10;

f = chebfun('(sin(1-x)-(1-x))./(1-x).^2',[1 4],'exps',[-2 0]);
u = cumsum(f);
a = f.ends(1) + .01;
h = cumsum(f{a,f.ends(2)})+u(a);
subplot(4,2,1), plot(u,'b',h,'--g')    
err = h - restrict(u,[a f.ends(2)]);
nerr(1) = norm(err,inf);
pass(1) = nerr(1) < tol;

f = chebfun('(sin(x))./x.^2',[-3 0],'exps',[0 -2]);
u = cumsum(f);
b = f.ends(2) - .01;
h = cumsum(f{f.ends(1), b});
subplot(4,2,2),plot(u,'b',h,'--g')
ylim([-1,1])
err = h - restrict(u,[f.ends(1) b]);
nerr(2) = norm(err,inf);
pass(2) = nerr(2) < tol;

f = chebfun('1./(1+x)',[-1 3],'exps',[-1 0]);
u = cumsum(f);
subplot(4,2,3),plot(u,'b'); hold on
xx = linspace(-.9,3);
h = log((1+xx)/4);
plot(xx,h,'--g'); hold off
err = u(xx) - h;
nerr(3) = norm(err,inf);
pass(3) = nerr(3) < tol;

f = chebfun('sin(x)./(1+x)',[-1 0],'exps',[-1 0]);
u = cumsum(f);
a = f.ends(1) + .05;
h = cumsum(f{a, f.ends(2)})+u(a);
subplot(4,2,4), plot(u,'b',h,'--g')
err = h - restrict(u,[a f.ends(2)]);
nerr(4) = norm(err,inf);
pass(4) = nerr(4) < tol;

f = chebfun('sin(x)./(1-x)',[0 1],'exps',[0 -1]);
u = cumsum(f);
b = f.ends(2) - .05;
h = cumsum(f{f.ends(1), b});
subplot(4,2,6), plot(u,'b',h,'--g')  
err = h - restrict(u,[f.ends(1) b]);
nerr(5) = norm(err,inf);
pass(5) = nerr(5) < tol;

f = chebfun({'exp(2*x)+pi','1./(1-x).^2'},[-1 0 1],'exps',[0 0 -2]);
u = cumsum(f);
b = f.ends(end) - .01;
h = cumsum(f{f.ends(1), b});
subplot(4,2,5), plot(u,'b',h,'--g')    
err = h - restrict(u,[f.ends(1) b]);
nerr(6) = norm(err,inf);
pass(6) = nerr(6) < tol;
