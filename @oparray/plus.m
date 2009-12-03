function C = plus(A,B)
% +   Sum of oparrays.

% Copyright 2008 by Toby Driscoll. 
% See http://www.maths.ox.ac.uk/chebfun/.

%  Last commit: $Author$: $Rev$:
%  $Date$:


if isempty(A) || isempty(B)
  C = oparray({});
else
  op = cellfun( @(a,b) anon('@(u) feval(a,u)+feval(b,u)',{'a','b'},{a,b}), A.op,B.op,...
    'uniform',false );
%  op = cellfun( @(a,b) @(u) a(u)+b(u), A.op,B.op,'uniform',false );

  C = oparray(op);
end

end
