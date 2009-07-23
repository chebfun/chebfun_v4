function pass = maxdegree
% Probes if the maxdegree is working in resampling on and off modes.

pref = chebfunpref; pref.resmapling = true; pref.maxdegree = 100;
warning('off','CHEBFUN:auto')

f = chebfun(@(x) sin(200*x),pref);
pass(1) = length(f) == 101;

pref.resmapling = false;
f = chebfun(@(x) sin(200*x),pref);
pass(2) = length(f) == 101;

warning('on','CHEBFUN:auto')



