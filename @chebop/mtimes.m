function C = mtimes(A,B)

if isa(A,'double')
  C=A; A=B; B=C;    % swap to make A a chebop
end

switch(class(B))
  case 'double'
    C = chebop(B*A.varmat, @(u) B*feval(A.oper,u), A.fundomain );
    C.difforder = A.difforder;
  case 'chebop'
    dom = domaincheck(A,B);
    C = chebop(A.varmat*B.varmat, @(u) feval( A.oper, feval(B.oper,u) ), dom );
    C.difforder = A.difforder + B.difforder;
  case 'chebfun'
    dom = domaincheck(A,B);
    if A.validoper
      C = feval(A.oper,B);
    else
      C = chebfun( @(x) value(x), dom );
    end
  otherwise
    error('chebop:mtimes:badoperand','Unrecognized operand.')
end

% NB: We are assuming x(1)=-1, but using old chebfuns for now.
  function v = value(x)
    N = length(x);
    L = feval(A.varmat,N);  Bx = B(flipud(x));
    v = flipud(L*Bx);
    v = filter(v,1e-8);
  end


end

