function Fout = sech(F)
% SECH   Hyperbolic secant of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) sech(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(-diag(tanh(F))*sech(F))*jacobian(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum;
end