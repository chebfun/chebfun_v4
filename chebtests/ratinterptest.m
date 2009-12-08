
function pass = ratinterptest

% Check a few basics with ratinterp

[d,x] = domain(1,3);
f = abs(exp(x)-5);
[p,q,r] = ratinterp(f,2,3,chebpts(6,[1,3]));
pass(1) = ( (length(p)==3) & (length(q)==4) );

pass(2) = norm(f-p./q,inf)<0.6;
xx = linspace(1,3,300);
pass(3) = max(abs((f(xx)-r(xx))))<0.6;
