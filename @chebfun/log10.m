function Fout = log10(F)
% LOG10   Base 10 logarithm of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) log10(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('diag1 = (1/log(10))*diag(1./F); der2 = diff(F,u,''linop''); der = diag1*der2; nonConst = ~der2.iszero;',{'F'},{F(k)},1);
    Fout(k).ID = newIDnum();
end