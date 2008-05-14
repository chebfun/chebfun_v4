function bc = getbc(A)

% Unites the left bc and right bc into a single structure.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

bc = struct('left',A.lbc,'right',A.rbc);

end