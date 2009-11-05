function Fout = asech(F)
% ASECH   Inverse hyperbolic cosecant of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) asech(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(-1./(F*sqrt(1-F.^2)))jacobian(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();  
end