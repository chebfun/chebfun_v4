function Fout = erfinv(F)
% ERFINV   Inverse error function for a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) erfinv(x));
for k = 1:numel(F)
  Fout(k).jacobian = anon('diag1 = diag(exp(Fout.^2)*sqrt(pi)/2); der2 = diff(F,u); der = diag1*der2; nonConst = ~der2.iszero;',{'F' 'Fout'},{F(k) Fout(k)},1);
  Fout(k).ID = newIDnum();
end