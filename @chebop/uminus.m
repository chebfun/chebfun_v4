function Nout = uminus(N)
% -  Negate a chebop.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.
 
Nout = N;  %change if ID's are added!
Nout.op = @(u) -N.op(u);
Nout.opshow = cellfun(@(s) ['- (',s,')'],N.opshow,'uniform',false);

end