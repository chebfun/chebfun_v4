function C = plus(A,B)
% +   Sum of chebops.
% If A and B are chebops, A+B returns the chebop that represents their
% sum. If one is a scalar, it is interpreted as the scalar times the
% identity operator.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

if isa(A,'double')
  C=A; A=B; B=C;    % swap to make A a chebop
end

% Scalar expansion using identity.
if isnumeric(B) && numel(B)==1
  if diff(A.blocksize)~=0
    error('chebop:plus:expandsquare',...
      'Scalars can be added only to square chebops.')
  end
  m = A.blocksize(1);
  B = B*blockeye(domain(A),m);
end

if isa(B,'chebop')
  dom = domaincheck(A,B);
  if A.blocksize~=B.blocksize
    error('chebop:plus:sizes','Chebops must have identical sizes.')
  end

  op = @(u) feval(A.oper,u) + feval(B.oper,u);
  order = max( A.difforder, B.difforder );
  C = chebop( A.varmat+B.varmat, op, dom, order );
  C.blocksize = A.blocksize;

else
  error('chebop:plus:badoperand','Unrecognized operand.')
end 

end