function Fout = erfinv(F)
% ERFINV   Inverse error function for a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) erfinv(x));
for k = 1:numel(F)
  Fout(k).jacobian = anon('@(u) diag(exp(Fout.^2)*sqrt(pi)/2)*jacobian(F,u)',{'F' 'Fout'},{F(k) Fout(k)});
  Fout(k).ID = newIDnum();
end