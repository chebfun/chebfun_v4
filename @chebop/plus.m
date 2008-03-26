function C = plus(A,B)
if isa(A,'double')
  C=A; A=B; B=C;    % swap to make A a chebop
end

switch(class(B))
  case 'double'
    C = chebop(B+A.varmat, @(u) B+feval(A.oper,u) );
    C.difforder = A.difforder;
  case 'chebop'
    dom = domaincheck(A,B);
    C = chebop(A.varmat+B.varmat, @(u) feval(A.oper,u) + feval(B.oper,u), dom );
    C.difforder = max( A.difforder, B.difforder );
  otherwise
    error('chebop:plus:badoperand','Unrecognized operand.')
end 
end