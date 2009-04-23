function Fout = imag(F)
% IMAG   Complex imaginary part.
% IMAG(F) is the imaginary part of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = -real(1i*F);