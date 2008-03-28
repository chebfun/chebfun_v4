function C = uminus(A)
C = chebop( -A.varmat, @(u) -feval(A.oper,u), domain(A) );
C.difforder = A.difforder;
end