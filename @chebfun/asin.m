function Fout = asin(F)
% ASIN   Arcsine of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) asin(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(1./sqrt(1-F.^2))*jacobian(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();  
end