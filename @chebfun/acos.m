function Fout = acos(F)
% ACOS   Arccosine of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) acos(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon(@(u) diag(-1./(1-F.^2))*jacobian(F,u),{'F'},{F(k)});
    Fout(k).ID = newIDnum();
end