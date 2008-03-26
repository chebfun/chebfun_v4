function C = transpose(A)
C = varmat( @(n) feval(A,n).' );
end