  function C = ctranspose(A)
  C = varmat( @(n) feval(A,n)' );
  end