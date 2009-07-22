function pass = cftest
f = chebfun('exp(x)');
[p,lam] = cf(f,2);
pass1 = (abs(lam-0.045017)<1e-4);
f = chebfun('exp(-1+x/2)',[0 4]);
[p,lam] = cf(f,2);
pass2 = (abs(lam-0.045017)<1e-4);
pass = pass1 && pass2;
