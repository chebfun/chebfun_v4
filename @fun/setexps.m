function f = setexps(f,newexps)

oldexps = f.exps;
ends = f.map.par(1:2);

rescl = (2/diff(ends))^sum(oldexps-newexps);
if any(isinf(ends)), rescl = 1; end

f = rescl*f;
f.exps = newexps;