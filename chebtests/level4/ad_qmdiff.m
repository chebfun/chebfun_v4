function pass = ad_qmdiff
% Check if automatic differentiation of a quasimatrix with respect
% to the columns of another quasimatrix works.

[d,x] = domain(-1,1);
u = [ chebfun('x')  chebfun('x') ];
f = [ u(:,1)  x.*u(:,2) ];
A = diff(f,u);

A4 = full(A(4));

pass = sum(abs(diag(A4))) == 7;
