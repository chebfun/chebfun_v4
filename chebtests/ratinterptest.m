
function pass = ratinterptest

% Check a few basics with ratinterp

[d,x] = domain(1,3);
f = abs(exp(x)-5);
[p,q,r] = ratinterp(f,2,3);
pass(1) = ( (length(p)==3) & (length(q)==4) );

pass(2) = norm(f-p./q)<.01;
