% This script displays some of the new features in version 3 for unbounded 
% intervals
%
% Rodrigo Platte, Dec 2009 
%

% Representation of the reciprocal of the gamma function on [-4 inf]
f  = chebfun(@(x) 1./gamma(x), [-4 inf]);

% The plot of f, its integral, and the maximum of the two functions
F = cumsum(f);
plot(f,'b',F,'r',max(f,F),'--g')

% the global minimum of f:
[ym,xm] = min(f);
hold on, plot(xm,ym,'*r'), shg

% The total variation of f
norm(diff(f),1)

% The first 5 roots of f (other roots are a consequence of the decay of f
% at infinity):
r = roots(f);
r(1:5)




