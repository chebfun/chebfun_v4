function pass = chebop_diff
% Checks if the differentiation chebop is equivalent to differentiating
% a chebfun.

d = domain(-3,-1.5);
D = diff(d);
f = chebfun(@(x) exp(sin(x).^2+2),d);
pass = norm(D*f - diff(f)) < chebfunpref('eps');
