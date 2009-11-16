function pass = extracting_roots
tol = 100*chebfunpref('eps');

F = @(x) cos(x);
var = {};
dd = {domain([-1,1]) domain([-1 sqrt(2)])};

l = -1;
for k = 1:2
    for j = 1:2
        for i = 1:2
            l = l+2;

            d = dd{j}; ab = d.ends;

            % left root
            f = chebfun(@(x) (x-ab(1)).^i.*F(x),d,var{:});
            h = f;
            h.funs(1) = extract_roots(f.funs(1));
            xx = linspace(d);
            pass(l) = norm(f(xx)-h(xx),inf) < tol;
            
            % right root
            f = chebfun(@(x) (ab(2)-x).^i.*F(x),d,var{:});
            h = f;
            h.funs(1) = extract_roots(f.funs(1));
            xx = linspace(d);
            pass(l+1) = norm(f(xx)-h(xx),inf);
        end
    end
    var = {'map',{'kte',.99}};
end