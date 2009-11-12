function pass = inverseq

tol = 100*chebfunpref('eps');

f = chebfun('(x.^2+4*x-1)/4');
g = chebfun(@(x) roots(x-f),'vectorise','resampling','off','blowup','off');
h = chebfun(@(x) roots(x-g),'vectorise','resampling','off','blowup','off');

h = simplify(h,tol);

pass = (norm(f-h,inf) < tol) && (length(f) == length(h));
