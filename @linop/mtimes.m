function C = mtimes(A,B)
% *  Chebop multiplication or operator application.
% If A and B are linops, or if one is scalar and the other is a linop,
% then A*B is a linop that represents their composition/product.
%
% If A is a linop and U is a chebfun, then A*U applies the operator A to
% the function U. If the infinite-dimensional form of A is known, it is
% used. Otherwise, the application is done through finite matrix-vector
% multiplications until the chebfun constructor is satisfied with
% convergence. In all cases, boundary conditions on A are ignored.
%
% See also linop/mldivide.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.
%  Last commit: $Author$: $Rev$:
%  $Date$:

persistent storage
if isempty(storage), storage = struct([]); end
use_store = cheboppref('storage');

if isa(A,'double')
   % We allow double*linop if the inner dimensions match--i.e., the linop
   % is really a functional. Or (below) if A is scalar.
  [m,n] = size(A);
  if max(m,n)>1 && n==size( feval(B,11), 1 )
    mat = A*B.varmat;
    op = A*B.oparray;
    order = B.difforder;
    C = linop(mat,op,domain(B),order);
    return
  else
    C=A; A=B; B=C;    % swap to make sure A is a linop
  end
end

switch(class(B))
  case 'double'     % linop * scalar
    if isempty(B), C = []; return, end  % linop*[] = []
    [m n] = size(B);
    if max(m,n) == 1
      C = copy(A);
      C.varmat = B*C.varmat;
      C.oparray = B*C.oparray;
    elseif n == 1
      error('LINOP:mtimes:numericvector','Chebop-vector multiplication is not well defined.')
    else
      error('LINOP:mtimes:numericmatrix','Chebop-matrix multiplication is not well defined.')
    end
  case 'linop'     % linop * linop
    dom = domaincheck(A,B);
    if size(A,2) ~= size(B,1)
      error('LINOP:mtimes:size','Inner block dimensions must agree.')
    end
    mat = A.varmat * B.varmat;
    op =  A.oparray * B.oparray;
    order = A.difforder + B.difforder;
    C = linop(mat,op,dom,order);
    C.blocksize = [size(A,1) size(B,2)];

  case 'chebfun'    % linop * chebfun
    dom = domaincheck(A,B);
    if isinf(size(B,2))
      error('LINOP:mtimes:dimension','Inner dimensions do not agree.')
    end
   
    if (A.blocksize(2) > 1) && (A.blocksize(2)~=size(B,2))
      error('LINOP:mtimes:blockdimension',...
        'Number of column blocks must equal number of quasimatrix columns.')
    end
    
    % Behavior for quasimatrix B is different depending on whether
    % A is a block operator.
    C = [];
    if A.blocksize(2)==1    % apply to each column of input
      for k = 1:size(B,2)  
        if ~isempty(A.oparray)   % functional form
          Z = feval(A.oparray,B(:,k));
        else                     % matrix application
          combine = 1;  % no component combination required
          Z = chebfun( @(x) value(x,B(:,k)), dom, chebopdefaults );
        end
        C = [C Z]; 
      end
    else                    % apply to multiple variables
      if ~isempty(A.oparray)   % functional form
        C = feval(A.oparray,B);
      else
        V = [];  % force nested function overwrite
        % For adaptation, combine solution components randomly.
        combine = randn(A.blocksize(2),1);  
        c = chebfun( @(x) value(x,B), dom, chebopdefaults );  % adapt
        % Now V is defined with values of each component at cheb points.
        for k = 1:size(B,2)
          c = chebfun( V(:,k), dom, chebopdefaults );
          Z = chebfun( @(x) c(x), dom, chebopdefaults );  % to force simplification
          C = [C Z];
        end
      end
    end
           
  otherwise
    error('LINOP:mtimes:badoperand','Unrecognized operand.')
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

