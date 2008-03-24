function C = minus(A,B)

C = chebop( @(n) feval(A,n) - feval(B,n) );
end