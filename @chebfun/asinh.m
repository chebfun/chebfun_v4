function Fout = asinh(F)
% ASINH   Inverse hyperbolic sine of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) asinh(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon(@(u) diag(1./sqrt(F.^2+1))jacobian(F,u),{'F'},{F(k)});
    Fout(k).ID = newIDnum();
end