function Fout = sech(F)
% SECH   Hyperbolic secant of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) sech(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(-diag(tanh(F))*sech(F))*diff(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum;
end