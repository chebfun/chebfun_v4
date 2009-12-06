function f = setexps(f,newexps)

oldexps = f.exps;
ends = f.map.par(1:2);

rescl = (2/diff(ends))^sum(oldexps-newexps);

f = rescl*f;
f.exps = newexps;