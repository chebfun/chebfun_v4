function C = mpower(A,m)
C = varmat( @(n) feval(A,n) ^ m );
end
