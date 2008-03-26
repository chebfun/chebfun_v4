function C = horzcat(A,B)
C = varmat( @(n) [ feval(A,n) feval(B,n) ] );
end