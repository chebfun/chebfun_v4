function pass = ellipj_test

pass = test(.005) && test(.995);

function pass = test(m)
tol = 100*chebfunpref('eps');

K = ellipke(m);
x = chebfun('x',[0,4*K]);
[sn cn dn] = ellipj(x,m);

% test values
pass1 = abs(sn(K)-1)<tol && abs(cn(K))<tol && abs(dn(K)-sqrt(1-m))<tol;

% test periodicity
pass2 = abs(sn(0)-sn(4*K))<tol && abs(sn(0)-sn(4*K))<tol && abs(dn(K)-dn(3*K))<tol;

% test relations
% pass3 = norm(-dn.^2+1-m*sn.^2,inf) < tol;
% pass4 = norm(sn.^2+cn.^2-1,inf) < tol;

% pass = pass1 & pass2 & pass3 & pass4;

pass = pass1 & pass2;