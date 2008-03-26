function C = uminus(A)
C = chebop( -A.varmat, @(u) -u, domain(A) );
C.difforder = A.difforder;
end