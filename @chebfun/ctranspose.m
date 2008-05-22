function Fout = ctranspose(F)
% '	  Complex conjugate transpose.
% F' is the complex conjugate transpose of F.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

Fout = transpose(conj(F));
