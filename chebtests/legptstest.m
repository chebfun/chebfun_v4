function pass = legptstest

% Nick Hale  22/04/2009

tol = chebfunpref('eps');

N = 32;
[x1 w1] = legpts(N,'GW');
[x2 w2] = legpts(N,'fast');

pass1 = norm(x1-x2,inf) + norm(w1-w2,inf) < 100*tol;

N = 129;
[x1 w1] = legpts(N,'GW');
[x2 w2] = legpts(N,'fast');
pass2 = norm(x1-x2,inf) + norm(w1-w2,inf) < 100*tol;

pass = pass1 && pass2;

