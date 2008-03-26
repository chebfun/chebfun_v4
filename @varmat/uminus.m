 function C = uminus(A)
 C = varmat( @(n) -feval(A,n) );
 end
  