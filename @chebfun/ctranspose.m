function Fout = ctranspose(F)
% '	  Complex conjugate transpose.
% F' is the complex conjugate transpose of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = transpose(conj(F));
