function F = transpose(F)
% .'   Transpose
% F.' is the non-conjugate transpose of F.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

for k = 1:numel(F), F(k).trans=not(F(k).trans); end
F=builtin('transpose',F);
