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

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

if isa(A,'double')
  C=A; A=B; B=C;    % swap to make sure A is a chebop
end

switch(class(B))
  case 'double'     % chebop * scalar
    C = chebop(B*A.varmat, @(u) B*feval(A.oper,u), A.fundomain, A.difforder );
    C.blocksize = A.blocksize;
    
  case 'chebop'     % chebop * chebop
    dom = domaincheck(A,B);
    if size(A,2) ~= size(B,1)
      error('chebop:mtimes:size','Inner block dimensions must agree.')
    end
    order = A.difforder + B.difforder;
    op =  @(u) feval( A.oper, feval(B.oper,u) );
    mat = A.varmat*B.varmat;
    C = chebop(mat,op,dom,order);

  case 'chebfun'    % chebop * chebfun
    dom = domaincheck(A,B);
    if isinf(size(B,2))
      error('chebop:mtimes:dimension','Inner dimensions do not agree.')
    end
    % Block operator case is special.   
    if (A.blocksize(2) > 1) && (A.blocksize(2)~=size(B,2))
      error('chebop:mtimes:blockdimension',...
        'Number of column blocks must equal number of quasimatrix columns.')
    end
    if A.validoper   % operator form
      C = feval(A.oper,B); 
    else             % adaptive matrix multiplication
      if A.blocksize(2)==1
        % Apply to each column of input.
        C = chebfun;
        combine = 1;  % no component combination required
        for k = 1:size(B,2)
          C(:,k) = chebfun( @(x) value(x,B(:,k)), dom );
        end
      else
        % Apply to entire input representing multiple variables.
        V = [];  % to get nested function overwrite
        % For adaptation, combine solution components randomly.
        combine = randn(A.blocksize(2),1);   
        c = chebfun( @(x) value(x,B), dom );  % adapt
        % Now V is defined with values of each component at cheb points.
        C = chebfun;
        for k = 1:size(B,2)
          c = chebfun( V(:,k), dom );
          C(:,k) = chebfun( @(x) c(x), dom );  % to force simplification
        end
      end
    end

  otherwise
    error('chebop:mtimes:badoperand','Unrecognized operand.')
end

  function v = value(x,f)
    N = length(x);
    L = feval(A.varmat,N); 
    fx = feval(f,x);  fx = fx(:);
    v = L*fx;
    V = reshape(v,N,A.blocksize(1));
    v = V*combine;
    v = filter(v,1e-8);
  end

end

