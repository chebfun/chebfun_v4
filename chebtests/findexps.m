function pass = findexps

% Tests automatic exps computation
% Nick Hale, Nov 2009

tol = chebfunpref('eps');
for k = 1:10
    f = chebfun(@(x) 1./x.^k,[0 1],'blowup','on');
    g = chebfun(@(x) 1./x.^k,[-1 0],'blowup','on');
    pass(k) = ~(abs(f.exps(1)+k) + abs(g.exps(2)+k));
end

f = chebfun(@(x) x.^10,[0,1],'blowup','on');
pass(k+1) = (f.exps(1) == 0);
