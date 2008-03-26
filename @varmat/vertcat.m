 function C = vertcat(A,B)
 C = varmat( @(n) [ feval(A,n); feval(B,n) ] );
 end