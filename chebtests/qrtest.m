function pass = qrtest

% Nick Trefethen  24 June 2008
tol = chebfunpref('eps');
x = chebfun('x',[0 1]);
A = [x 1i*x 1 1+1i (2-1i)*x];
pass1 = (rank(A)==2);
[Q,R] = qr(A);
pass2 = (abs(cond(Q)-1)<1e-13*(tol/eps));
pass3 = (norm(A-Q*R)<1e-13*(tol/eps));
pass = pass1 && pass2 && pass3;
