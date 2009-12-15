function Fout = ctranspose(F)
% '	  Complex conjugate transpose.
% F' is the complex conjugate transpose of F.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = transpose(conj(F));
