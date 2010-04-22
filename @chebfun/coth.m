function Fout = coth(F)
% COTH   Hyperbolic cotangent of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) coth(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) -diag(csch(F).^2)*diff(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();
end