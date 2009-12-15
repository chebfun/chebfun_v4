function Fout = log2(F)
% LOG2   Base 2 logarithm of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) log2(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) (1/log(2))*diag(1./F)*jacobian(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();
end