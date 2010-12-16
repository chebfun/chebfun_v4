function C = uminus(A)
% -   Negate oparray.

% Copyright 2008-2009 by Toby Driscoll. 
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

if isempty(A) 
  C = oparray({});
  return
end

fun = @(a) anon('@(u) -feval(a,u)',{'a'},{a},2);
op = cellfun( fun, A.op, 'uniform',false );
C = oparray(op);

end
