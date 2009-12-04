function f = replace_roots(f)

% Get the exponents
exps = get(f,'exps');
if ~any(exps >= 1)
    return % nothing to do
end

% Get the domain
d = f.map.par(1:2);

% Get the map
map = f.map;

f.exps = [0 0];
mask = exps >= 1;
newexps = exps;
newexps(mask) = exps(mask) - floor(exps(mask));
pow = exps-newexps;

ends = map.par(1:2);
C = (2/diff(ends)).^sum(exps-newexps);

if strcmp(map.name,'linear')
    f = prolong(f,f.n+sum(pow));
    x = get(f,'points');
    mult = (x-d(1)).^pow(1).*(d(2)-x).^pow(2);
    f.vals = mult.*f.vals;
    f.scl.v = norm(f.vals,inf);
else
    mult = fun(@(x) (x-d(1)).^pow(1).*(d(2)-x).^pow(2),map);
    f = f.*mult;
end
f = C*f;    
f.exps = newexps;