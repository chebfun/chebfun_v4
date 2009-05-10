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

% integrate first 30 (even) powers of x correctly?
pass3 = true;
for j = 2:2:30
    pass3 = pass3 && 2/sum(w2*(x2.^j))-(j+1) < 10000*tol;
end

pass = pass1 && pass2 && pass3;

