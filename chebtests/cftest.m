function pass = cf
f = chebfun('exp(x)');
[p,q,lam] = cf(f,2);
pass(1) = (abs(lam-0.045017)<1e-4);
f = chebfun('exp(-1+x/2)',[0 4]);
[p,q,lam] = cf(f,2);
pass(2) = (abs(lam-0.045017)<1e-4);

