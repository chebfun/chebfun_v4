function pass = testpolyfit
% Rodrigo Platte Jan 2009
% Tests the polyfit commmand

tol = chebfunpref('eps');

x = chebfun('x',[-2 2]);
g = sign(x);
f0 = polyfit(g, 0);
pass0 = norm(f0,inf) < tol;
f1 = polyfit(g, 1);
pass1 = norm(f1 - chebfun([-1.5 1.5],[-2 2]) ,inf) < 10*tol;
f2 = polyfit(g, 2);
pass2 = norm(f2 - chebfun([-1.5 1.5],[-2 2]) ,inf) < 10*tol;
f3 = polyfit(g, 3);
pass3 = norm(f3 - chebfun([-.625 -1.1328125 1.1328125 .625],[-2 2]) ,inf) < 10*tol;
pass = pass0 && pass1 && pass2 && pass3;
