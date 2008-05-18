function C = mtimes(A,B)
% *  Chebop multiplication or operator application.
% If A and B are chebops, or if one is scalar and the other is a chebop,
% then A*B is a chebop that represents their composition/product.
%
% If A is a chebop and U is a chebfun, then A*U applies the operator A to
% the function U. If the infinite-dimensional form of A is known, it is
% used. Otherwise, the application is done through finite matrix-vector
% multiplications until the chebfun constructor is satisfied with
% convergence. In all cases, boundary conditions on A are ignored.
%
% See also chebop/mldivide.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

if isa(A,'double')
  C=A; A=B; B=C;    % swap to make sure A is a chebop
end

switch(class(B))
  case 'double'     % chebop * scalar
    C = chebop(B*A.varmat, @(u) B*feval(A.oper,u), A.fundomain, A.difforder );
  case 'chebop'     % chebop * chebop
    dom = domaincheck(A,B);
    order = A.difforder + B.difforder;
    op =  @(u) feval( A.oper, feval(B.oper,u) );
    mat = A.varmat*B.varmat;
    C = chebop(mat,op,dom,order );
  case 'chebfun'    % chebop * chebfun
    dom = domaincheck(A,B);
    if isinf(size(B,2))
      error('chebop:mtimes:dimension','Inner dimensions do not agree.')
    end
    if A.validoper
      C = feval(A.oper,B);
    else
      C = chebfun;
      for k = 1:size(B,2)
        f = B(:,k);
        C(:,k) = chebfun( @(x) value(x), dom );
      end
    end
  otherwise
    error('chebop:mtimes:badoperand','Unrecognized operand.')
end

  function v = value(x)
    N = length(x);
    L = feval(A.varmat,N);  
    v = L*f(x);
    v = filter(v,1e-8);
  end


end

