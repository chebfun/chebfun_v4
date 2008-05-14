function C = plus(A,B)
% +  Sum of chebops.
% If A and B are chebops, A+B returns the chebop that represents their
% sum. If one is a scalar, it is interpreted as the scalar times the
% identity operator.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

if isa(A,'double')
  C=A; A=B; B=C;    % swap to make A a chebop
end

% Scalar expansion using identity.
if isnumeric(B) && numel(B)==1
  B = B*eye(A.fundomain);
end

if isa(B,'chebop')
  dom = domaincheck(A,B);
  mat = A.varmat+B.varmat;
  op = @(u) feval(A.oper,u) + feval(B.oper,u);
  order = max( A.difforder, B.difforder );
  C = chebop(mat,op,dom,order);
else
  error('chebop:plus:badoperand','Unrecognized operand.')
end 

end