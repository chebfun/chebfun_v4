function Fout = imag(F)
% IMAG   Complex imaginary part.
% IMAG(F) is the imaginary part of F.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = -real(1i*F);