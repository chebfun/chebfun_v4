function B = copy(A)

% Copy a linop into another, preserving everything but the ID number.

% Copyright 2009 by Toby Driscoll.
% See www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

B = A;
B.ID = newIDnum();

end
