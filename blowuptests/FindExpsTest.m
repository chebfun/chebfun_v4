function pass = FindExpsTest

% Tests automatic exps computation
% Nick Hale, Nov 2009

tol = chebfunpref('eps');
for k = 1:10
    f = chebfun(@(x) 1./x.^k,[0 1]);
    g = chebfun(@(x) 1./x.^k,[-1 0]);
    pass(k) = ~(abs(f.exps(1)+k) + abs(g.exps(2)+k));
end
