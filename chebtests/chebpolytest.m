function pass = chebpolytest

% Nick Trefethen  29 December 2008

% Tests of the form chebfun = chebpoly(integer):

tol = chebfunpref('eps');

T5 = chebpoly(5);
x = [0 .4 1];
exact = [0 .88384 1];
pass1 = (norm(T5(x)-exact)<1e-14*(tol/eps));

T5b = chebpoly(5,[1,9]);
xb = 4*x + 5;
pass2 = (norm(T5b(xb)-exact)<1e-14*(tol/eps));

T100 = chebpoly(100);
pass3 = (abs(sum(T100)-(-2/9999)) < 1e-15*(tol/eps));

% Tests of the form vector = chebpoly(chebfun):

a = chebpoly(chebfun('exp(x).*sin(x)')); a = a(end:-1:1);
exacta = [0.496529947609122 1.228320669845808 0.494795283026613]';
pass4 = (norm(a(1:3)-exacta)<1e-14*(tol/eps));

% Combined tests:

f = chebpoly(5) + .25*chebpoly(4);
exactf = [1 .25 0 0 0 0]';
pass5 = norm(exactf - chebpoly(f)) < 1e-15*(tol/eps);

pass = pass1 && pass2 && pass3 && pass4 && pass5;

