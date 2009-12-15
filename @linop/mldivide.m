function C = mldivide(A,B,tolerance)
% \  Solve a linear operator equation.
% U = A\F solves the linear system A*U=F, where U and F are chebfuns and A
% is a chebop. If A is a differential operator of order M, a warning will
% be issued if A does not have M boundary conditions. In general the
% function may not converge in this situation.
%
% The algorithm is to realize and solve finite linear systems of increasing
% size until the chebfun constructor is satisfied with the convergence.
% This convergence is in a relative sense for U, which may not be
% appropriate in some situations (e.g., Newton's method finding a small
% correction). To set a different scale S for the relative accuracy, use 
% A.scale = S before solving.
%
% EXAMPLE
%   % Newton's method for (u')^2+6u=1, u(0)=0.
%   d = domain(0,1);  D = diff(d);
%   f = @(u) diff(u).^2 - 6*u - 1;
%   J = @(u) (diag(2*diff(u))*D - 6) & 'dirichlet';
%   u = chebfun('x',d);  du = Inf;
%   while norm(du) > 1e-12
%     r = f(u);  A = J(u);  A.scale = norm(u);
%     du = -(A\r);
%     u = u+du;
%   end
%
% See also linop/and, linop/mtimes.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.
%  Last commit: $Author$: $Rev$:
%  $Date$:

% For future performance, store LU factors of realized matrices.
persistent storage
if isempty(storage), storage = struct([]); end
use_store = cheboppref('storage');
maxdegree = cheboppref('maxdegree');

switch(class(B))
  case 'linop'
    %TODO: Experimental, undocumented.
    dom = domaincheck(A,B);
    C = linop( A.varmat\B.varmat, [], dom, B.difforder-A.difforder );  

  case 'double'
    if length(B)==1  % scalar expansion
      C = mldivide(A,chebfun(B,domain(A),chebopdefaults));
    else
      error('LINOP:mldivide:operand','Use scalar or chebfun with backslash.')
    end

  case 'chebfun'
    dom = domaincheck(A,B(:,1));
    m = A.blocksize(2);
    if (m==1) && (A.numbc~=A.difforder)
      warning('LINOP:mldivide:bcnum',...
        'Operator may not have the correct number of boundary conditions.')
    end
    settings = chebopdefaults;
    if nargin == 3
        settings.eps = tolerance;
    end
    V = [];  % so that the nested function overwrites it
    if isa(A.scale,'chebfun') || isa(A.scale,'function_handle')
      C = chebfun( @(x) A.scale(x)+value(x), dom, settings) - A.scale;
    else
      C = chebfun( @(x) A.scale+value(x), dom, settings) - A.scale;
    end
    
    % V has been overwritten by the nested value function.
    if m > 1
      for j = 1:m
        c = chebfun( V(:,j), dom, settings);
        C(:,j) = chebfun( @(x) c(x), dom, settings);
      end
    end
    
  otherwise
    error('LINOP:mldivide:operand','Unrecognized operand.')
end

  function v = value(x)
    N = length(x);
    if N > maxdegree+1
      msg = sprintf('Failed to converge with %i points.',maxdegree+1);
      error('LINOP:mldivide:NoConverge',msg)
    elseif N==1
      error('LINOP:mldivide:OnePoint',...
        'Solution requested at a lone point. Check for a bug in the linop definition.')
    elseif N <= A.numbc+1
      % Too few points: force refinement
      v = ones(N,1); 
      v(2:2:end) = -1;
      return
    end
    
    % Retrieve or compute LU factors of the matrix.
    if use_store && N > 5 && length(storage)>=A.ID ...
        && length(storage(A.ID).L)>=N && ~isempty(storage(A.ID).L{N})
      L = storage(A.ID).L{N};
      U = storage(A.ID).U{N};
      c = storage(A.ID).c{N};
      rowidx = storage(A.ID).rowidx{N};
    else  % have to compute L and U
      Amat = feval(A,N);
      [Bmat,c,rowidx] = bdyreplace(A,N);
      Amat(rowidx,:) = Bmat;
      d = A.fundomain;
      ab = d.ends;
      
      [L,U] = lu(Amat);
      if use_store && N>5   % store L and U
        % Very crude garbage collection! If over capacity, clear out
        % everything.
        ssize = whos('storage');
        if ssize.bytes > cheboppref('maxstorage')
          storage = struct([]);
        end
        storage(A.ID).L{N} = L;
        storage(A.ID).U{N} = U;
        storage(A.ID).c{N} = c;
        storage(A.ID).rowidx{N} = rowidx;
      end        
    end
    
    % Evaluate and modify RHS as needed.
    f = B(x,:);
    f = f(:);
    f(rowidx) = c;
      
    % Solve.
    v = U\(L\f);
     
    V = reshape(v,N,m);
    v = sum(V,2);
    v = filter(v,1e-8);

  end
      
end
