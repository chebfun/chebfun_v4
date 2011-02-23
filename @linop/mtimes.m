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
      if isreal(B) && ~B % B = 0 is special
          C = repmat(zeros(A.fundomain),A.blocksize(1),A.blocksize(2));
          C.iszero = 1+0*C.iszero;
      else
          C = copy(A);
          C.varmat = B*C.varmat;
          C.oparray = B*C.oparray;
      end
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

    % Find the zeros
    isz = ~(double(~A.iszero)*double(~B.iszero));
    
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
    
  case 'chebfun'    % linop * chebfun
    dom = domaincheck(A,B);
    dom = dom.endsandbreaks;
    if isinf(size(B,2))
      error('LINOP:mtimes:dimension','Inner dimensions do not agree.')
    end
   
    if (A.blocksize(2) > 1) && (A.blocksize(2)~=size(B,2))
      error('LINOP:mtimes:blockdimension',...
        'Number of column blocks must equal number of quasimatrix columns.')
    end
    
    % Deal with maps.
    % TODO : test this.
    map = mapcheck(get(B(:,1),'map'),get(B(:,1),'ends'),1);
    if ~isempty(map)
        settings.map = map;
    end   
    % Can't do this yet. 
    if ~isempty(map) && numel(map)~=numel(dom)-1
        warning('CHEBFUN:linop:mldivide:mapbreaks',...
            'New breakpoint introduced, so map data from RHS is ignored.');
        map = [];
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
%           Z = chebfun( @(x,N,bks) value_sys(x,B(:,k),N,bks), {dom}, chebopdefaults );
        end
        C = [C Z]; 
      end
    else                    % apply to multiple variables
      if ~isempty(A.oparray)   % functional form
        C = feval(A.oparray,B);
      else
        V = [];  % force nested function overwrite
        
%% old
%         For adaptation, combine solution components randomly.
        combine = randn(A.blocksize(2),1);  
        c = chebfun( @(x) value(x,B), dom, chebopdefaults );  % adapt       
        % Now V is defined with values of each component at cheb points.
        for k = 1:size(B,2)
          c = chebfun( V(:,k), dom, chebopdefaults );
          Z = chebfun( @(x) c(x), dom, chebopdefaults );  % to force simplification
          C = [C Z];
        end
    
%% new
%         settings = chebopdefaults;
%         c = chebfun( @(x,N,bks) value_sys(x,B,N,bks), {dom}, settings );
%         % V has been overwritten by the nested value function.
%         % We need to simplify it and store as the output.
%         C = chebfun; % Will contain the output.
%         for j = 1:A.blocksize(2)  % For each variable, build a chebfun.
%             tmp = chebfun;          % Temporary chebfun for the jth variable.
%             for k = 1:numel(dom)-1 % Loop over each subinterval.
%                 funk = fun( V{1}, dom(k:k+1), settings);
%                 tmp = [tmp ; set(chebfun,'funs',funk,'ends',dom(k:k+1),...
%                     'imps',[funk.vals(1) funk.vals(end)],'trans',0)];
%                 V(1) = [];
%             end
%             C(:,j) = simplify(tmp,settings.eps); % Simplify and store.
%         end
%         C = merge(C,settings.eps);
        
      end
    end

  otherwise
    error('LINOP:mtimes:badoperand','Unrecognized operand.')
end

  function v = value(x,f)
    N = length(x);
%     L = feval(A.varmat,{N,map,[]}); 
    L = feval(A.varmat,N); 
    fx = feval(f,x);  fx = fx(:);
    v = L*fx;
    V = reshape(v,N,A.blocksize(1));
    v = V*combine;
    v = filter(v,1e-8);
  end

  function v = value_sys(x,f,N,bks)
    % x is a cell array with the points for each function.
    % N is the number of points on each subinterval.
    % bks contains the ends of the subintervals.

    syssize = A.blocksize(1);     % Number of eqns in system.
    N = N{:};   bks = bks{:};     % We allow only the same discretization.
                                  % Size and breaks for each system.
    x = x{1};
    A
    L = feval(A,N,'nobc',map,bks);
    fx = feval(f,x);  fx = fx(:);
    size(L)
    size(fx)
    v = L*fx;
    
    V = mat2cell(v,repmat(N,1,syssize),1);  % Store for output.
    v = sum(reshape(v,[sum(N),syssize]),2); % Combine equations.
    % Filter
    csN = cumsum([0 N]);
    for ll = 1:numel(N)
        ii = csN(ll) + (1:N(ll));
        v(ii) = filter(v(ii),1e-8);
    end
    v = {v};                                % Output as cell array.
  end
   

end

