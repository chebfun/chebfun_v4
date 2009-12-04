function e = isempty(A)
% ISEMPTY   True for empty linop.

% Copyright 2008 by Toby Driscoll.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

e = isempty(A.varmat) && isempty(A.oparray);

end