function Fout = ctranspose(F)
% '	  Complex conjugate transpose.
% F' is the complex conjugate transpose of F.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

Fout = transpose(conj(F));
