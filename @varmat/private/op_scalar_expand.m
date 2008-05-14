function C = op_scalar_expand(op,A,B)

% Apply a function of two matrices, expanding one of the arguments if it
% happens to be scalar. Expansion is the usual matlab sense of copying a
% scalar to every position in the array.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

if isnumeric(A) && numel(A)==1
  C = varmat( @(n) op(A,feval(B,n)) );
elseif isnumeric(B) && numel(B)==1
  C = varmat( @(n) op(feval(A,n),B) );
else
  C = varmat( @(n) op(feval(A,n),feval(B,n)) );
end
end
