function pass = chebpadetest

% Nick Hale  22/04/2009

tol = chebfunpref('eps');

M = 4;
N = 4;
d = [-1, 0, 3];
P = chebfun(chebpolyval([-0.6817    0.0558    2.1122   -1.3813    0.5045]),d);
Q = chebfun(chebpolyval([0.5246   -0.2679   -0.8573    0.1155    1]),d);
R = P./Q;
[r p q] = chebpade(R,M,N);
err = norm(chebfun(P.funs(1),d(1:2))-p)+norm(chebfun(Q.funs(1),d(1:2))-q);
pass1 = err < 100*tol*R.scl;


M = 6;
N = 5;
[r p q] = chebpade( P./Q,M,N);
err = norm(chebfun(P.funs(1),d(1:2))-p)+norm(chebfun(Q.funs(1),d(1:2))-q);
pass2 = err < 100*tol*R.scl;

pass = pass1 && pass2;

