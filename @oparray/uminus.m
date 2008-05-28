function C = uminus(A)
% -   Negate oparray.

% Copyright 2008 by Toby Driscoll. See www.comlab.ox.ac.uk/chebfun.

if isempty(A) || isempty(B)
  C = oparray({});
  return
end

op = cellfun( @(a) @(u) -feval(a,u), A.op, 'uniform',false );
C = oparray(op);

end
