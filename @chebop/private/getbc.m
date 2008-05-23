function bc = getbc(A)

% Unites the left bc and right bc into a single structure.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

bc = struct('left',A.lbc,'right',A.rbc);

end