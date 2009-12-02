function C = uminus(A)
% -  Negate a chebop.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

C = A;
C.varmat = -C.varmat;
C.oparray = -C.oparray;

end