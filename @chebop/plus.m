function C = plus(A,B)
if isa(A,'double')
  C=A; A=B; B=C;    % swap to make A a chebop
end

if isnumeric(B) && numel(B)==1
  B = B*eye(domain(A));
end

if isa(B,'chebop')
  dom = domaincheck(A,B);
  C = chebop(A.varmat+B.varmat, @(u) feval(A.oper,u) + feval(B.oper,u), dom );
  C.difforder = max( A.difforder, B.difforder );
else
  error('chebop:plus:badoperand','Unrecognized operand.')
end 

end