function Fout = erfcx(F)
% ERFCX  Scaled complementary error function of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) erfcx(x));
for k = 1:numel(F)
  Fout(k).jacobian = anon('@(u) diag(-2/sqrt(pi) + 2*F.*Fout)*jacobian(F,u)',{'F' 'Fout'},{F(k) Fout(k)});
  Fout(k).ID = newIDnum();
end