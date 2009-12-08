function pass = cumsumunbnd
% Test cumsum with exps < 1. 
% This is still experimental, so the tolerance is REALLY high.
%
% Nick Hale, Dec 2009

chebfunpref('factory');
tol = 1e-10;

f = chebfun('(sin(1-x)-(1-x))./(1-x).^2',[1 3],'exps',[-2 0]);
u = cumsum(f);
a = f.ends(1) + .01;
h = cumsum(f{a,f.ends(2)})+u(a);
% subplot(2,1,1), plot(u,'b',h,'--g')    
err = h - restrict(u,[a f.ends(2)]);
nerr = norm(err,2);
pass(1) = nerr < tol;


f = chebfun('(cos(x))./x.^2',[-2 0],'exps',[0 -2]);
u = cumsum(f);
b = f.ends(2) - .01;
h = cumsum(f{f.ends(1), b});
% subplot(2,1,2), plot(u,'b',h,'--g')
err = h - restrict(u,[f.ends(1) b]);
nerr = norm(err,inf);
pass(2) = nerr < tol;