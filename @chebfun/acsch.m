function Fout = acsch(F)
% ACSCH   Inverse hyperbolic cosecant of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) acsch(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(-1./(F.*sqrt(1+F.^2)))*diff(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();  
end