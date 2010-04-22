function Fout = erfc(F)
% ERFC   Complementary error function of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) erfc(x));
for k = 1:numel(F)
  Fout(k).jacobian = anon('@(u) diag(-2*exp(-F.^2)/sqrt(pi))*diff(F,u)',{'F'},{F(k)});
  Fout(k).ID = newIDnum();
end