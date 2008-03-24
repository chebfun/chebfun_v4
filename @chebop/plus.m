function C = plus(A,B)

C = chebop( @(n) feval(A,n) + feval(B,n) );
end