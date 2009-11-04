function Fout = sqrt(F)
% SQRT   Square root.
% SQRT(F) returns the square root chebfun of a positive or negative chebfun F. 
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) sqrt(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) (1/2)*diag(1./Fout)*jacobian(F,u)',{'Fout','F'},{Fout(k) F(k)});
    Fout(k).ID = newIDnum;
end