function F = transpose(F)
% .'   Transpose
% F.' is the non-conjugate transpose of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

for k = 1:numel(F), F(k).trans=not(F(k).trans); end
F=builtin('transpose',F);
