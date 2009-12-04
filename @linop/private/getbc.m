function bc = getbc(A)

% Unites the left bc and right bc into a single structure.

% Copyright 2008 by Toby Driscoll.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

bc = struct('left',A.lbc,'right',A.rbc);

end