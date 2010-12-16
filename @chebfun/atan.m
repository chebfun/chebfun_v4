function Fout = atan(F)
% ATAN   Arctangent of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) atan(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('diag1 = diag(1./(1+F.^2)); der2 = diff(F,u); der = diag1*der2; nonConst = ~der2.iszero;',{'F'},{F(k)},1);
    Fout(k).ID = newIDnum();
end