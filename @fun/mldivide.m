function F = mldivide(c,f)
% \	Left scalar divide
% C\F divides the fun F by a scalar C.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

F = mrdivide(f,c);