function Fout = acot(F)
% ACOT   Inverse cotangent of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) acot(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('diag1 = diag(-1./(1+F.^2)); der2 = diff(F,u); der = mtimes(diag1,der2); nonConst = (~der2.iszero);',{'F'},{F(k)},1);
    Fout(k).ID = newIDnum();  
end