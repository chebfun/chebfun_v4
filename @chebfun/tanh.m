function Fout = tanh(F)
% TANH   Hyperbolic tangent of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) tanh(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon(@(u) diag(sech(F).^2)*jacobian(F,u),{'F'},{F(k)});
    Fout(k).ID = newIDnum;
end