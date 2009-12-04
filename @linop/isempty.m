function e = isempty(A)
% ISEMPTY   True for empty chebop.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

e = isempty(A.varmat) && isempty(A.oparray);

end