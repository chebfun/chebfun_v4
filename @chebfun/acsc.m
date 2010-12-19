function Fout = acsc(F)
% ACSC   Inverse cosecant of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for Chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) acsc(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('diag1 = diag(-1./(abs(F).*sqrt(F.^2-1))); der2 = diff(F,u); der = diag1*der2; nonConst = ~der2.iszero;',{'F'},{F(k)},1);
    Fout(k).ID = newIDnum();  
end
