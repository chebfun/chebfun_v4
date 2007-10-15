function F = prolong(f,n)

nfuns = length(f.funs);
ends = f.ends;
dint = diff(ends);
n = n - nfuns;
n0 = n;
n = round(n*dint./diff(domain(f)));
r = n0 - sum(n);
if r > 0
    [xx,I] = sort(dint,'descend');
    n(I(1:r)) = n(I(1:r)) + 1;
elseif r < 0
    [xx,I] = sort(dint,'descend');
    n(I(1:r)) = n(I(1:r)) - 1;
end

for i = 1:nfuns
    f.funs{i} = prolong(f.funs{i},n(i));
end
F = chebfun;
F.funs = f.funs; F.ends = f.ends;