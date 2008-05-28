function C = plus(A,B)
% +   Sum of oparrays.

% Copyright 2008 by Toby Driscoll. See www.comlab.ox.ac.uk/chebfun.

if isempty(A) || isempty(B)
  C = oparray({});
else
  op = cellfun( @(a,b) @(u) a(u)+b(u), A.op,B.op,...
    'uniform',false );
  C = oparray(op);
end

end
