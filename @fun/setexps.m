function f = setexps(f,newexps)

oldexps = f.exps;
if nargin == 2
    ends = f.map.par(1:2);
end

rescl = (2/diff(ends))^sum(oldexps-newexps);

f = rescl*f;
f.exps = newexps;
