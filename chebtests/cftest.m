function pass = cftest
f = chebfun('exp(x)');
[p,lam] = cf(f,2);
pass = (abs(lam-0.045017)<1e-4);