function Fout = csch(F)
% CSCH   Hyperbolic cosecant of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) csch(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon(@(u) diag(-diag(coth(F))*csch(F))*jacobian(F,u),{'F'},{F(k)});
    Fout(k).ID = newIDnum();
end