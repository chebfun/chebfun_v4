function C = uminus(A)
% -  Negate a chebop.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

%  Last commit: $Author: platte $: $Rev: 840 $:
%  $Date: 2009-11-27 18:01:24 -0500 (Fri, 27 Nov 2009) $:

C = A;
C.varmat = -C.varmat;
C.oparray = -C.oparray;

end