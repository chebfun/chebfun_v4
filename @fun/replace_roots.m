function f = replace_roots(f)

% Get the domain
d = f.map.par(1:2);
% Get the exponents
exps = get(f,'exps');
% Get the map
map = f.map;

if ~any(exps) > 1
    return
end

f.exps = [0 0];
mask = exps > 1;
newexps = exps;
newexps(mask) = exps(mask) - floor(exps(mask));
pow = exps-newexps;

mult = fun(@(x) (x-d(1)).^pow(1).*(d(2)-x).^pow(2),map);
f = f.*mult;
f.exps = newexps;