function C = op_scalar_expand(op,A,B)
if isnumeric(A) && numel(A)==1
  C = varmat( @(n) op(A,feval(B,n)) );
elseif isnumeric(B) && numel(B)==1
  C = varmat( @(n) op(feval(A,n),B) );
else
  C = varmat( @(n) op(feval(A,n),feval(B,n)) );
end
end
