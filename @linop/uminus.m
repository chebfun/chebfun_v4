function C = uminus(A)
% -  Negate a linop.

% Copyright 2008 by Toby Driscoll.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

C = copy(A);
C.varmat = -C.varmat;
C.oparray = -C.oparray;

end