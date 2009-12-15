function h = heaviside(f)
% HEAVISIDE delta function
%  H = HEAVISIDE(F) returns a chebfun H which is -1 when the chebfun F < 0, 
%  +1 when F > 0, and .5 when F == 0.
%  
%  See also chebfun/dirac
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

h = .5*(sign(f)+1);




