function Fout = acoth(F)
% ACOTH   Inverse hyperbolic cotangent of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) acoth(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(-1./(F.^2-1))*jacobian(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();  
end