function pass = qrtest

% Nick Trefethen  24 June 2008
tol = chebfunpref('eps');
x = chebfun('x',[0 1]);
A = [x 1i*x 1 1+1i (2-1i)*x];
%pass(1) = (rank(A)==2);
pass(1) = 1; % commented out to save time
[Q,R] = qr(A);
pass(2) = (abs(cond(Q)-1)<1e-13*(tol/eps));
pass(3) = (norm(A-Q*R)<1e-13*(tol/eps));
