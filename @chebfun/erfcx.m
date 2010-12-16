function Fout = erfcx(F)
% ERFCX  Scaled complementary error function of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) erfcx(x));
for k = 1:numel(F)
  Fout(k).jacobian = anon('diag1 = diag(-2/sqrt(pi) + 2*F.*Fout); der2 = diff(F,u); der = diag1*der2; nonConst = ~der2.iszero;',{'F' 'Fout'},{F(k) Fout(k)},1);
  Fout(k).ID = newIDnum();
end