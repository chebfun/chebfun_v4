function C = plus(A,B)
% +   Sum of oparrays.

% Copyright 2008 by Toby Driscoll. See www.comlab.ox.ac.uk/chebfun.

op = cellfun( @(a,b) @(u) feval(a,u)+feval(b,u), A.op,B.op,...
  'uniform',false );
C = oparray(op);

end
