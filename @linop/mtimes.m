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

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

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
      if isreal(B) && ~B% B = 0 is special
%           C = repmat(zeros(A.fundomain),A.blocksize(1),A.blocksize(2));
          C.iszero = 1+0*C.iszero;
          C.difforder = 0*C.difforder;
      else

      end
    elseif n == 1
      error('LINOP:mtimes:numericvector','Chebop-vector multiplication is not well defined.')
    else
      error('LINOP:mtimes:numericmatrix','Chebop-matrix multiplication is not well defined.')
    end
  case 'linop'     % linop * linop
%     dom = domaincheck(A,B);
    dom = domain(union(A.fundomain.endsandbreaks,B.fundomain.endsandbreaks));
    
    if size(A,2) ~= size(B,1)
      error('LINOP:mtimes:size','Inner block dimensions must agree.')
    end
    
%     % Hack for constant diagonal check
%     if max(size(A)) == 1 && A.isdiag
%         A3 = feval(A,3,'nobc'); B3 = feval(B,3,'nobc');
%         if size(B3,1) == 1 && ~any(diff(diag(A3)));
%             C = A3(1)*B;
%             return
%         end
%     end

    mat = A.varmat * B.varmat;
    op =  A.oparray * B.oparray;

    % Find the zeros
    isz = ~(double(~A.iszero)*double(~B.iszero));
    
    % Find the diagonals
    isd = zeros(size(A,1),size(B,2));
    for i1 = 1:size(A,1)
        for i2 = 1:size(B,2)
            isd(i1,i2) = double(logical(A.isdiag(i1,:)+B.iszero(:,i2)'))*double(logical(A.iszero(i1,:)'+B.isdiag(:,i2)));
        end
    end
    isd = isd == size(A,2);
    
    % Get the difforder
    [jj kk] = meshgrid(1:size(A,1),1:size(B,2));
    order = zeros(numel(jj),size(A,2));
    zr = zeros(numel(jj),size(A,2));
    for l = 1:size(A,2)
        order(:,l) = A.difforder(jj,l)+B.difforder(l,kk)';
        zr(:,l) = ~(~A.iszero(jj,l).*~B.iszero(l,kk)');
    end
    order(logical(zr)) = 0;
    order = max(order,[],2);
    order = reshape(order,size(A,1),size(B,2));
    if size(A,1)==size(B,2)
        order = order'; % What? WHY!?
    end
    order(isz) = 0;
        
    C = linop(mat,op,dom,order);
    C.blocksize = [size(A,1) size(B,2)];
    C.iszero = isz;
    C.isdiag = isd;
    
  case 'chebfun'    % linop * chebfun
    dom = domaincheck(A,B);
    dom = dom.ends;
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

