function F = transpose(F)
% .'   Transpose
% F.' is the non-conjugate transpose of F.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

for k = 1:numel(F), F(k).trans=not(F(k).trans); end
F=builtin('transpose',F);
