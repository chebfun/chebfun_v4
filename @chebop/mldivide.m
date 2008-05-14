function C = mldivide(A,B)
% \  Solve a chebop equation.
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
% See also chebop/and, chebop/mtimes.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

% For future performance, store LU factors of realized matrices.
persistent storage
if isempty(storage), storage = struct([]); end
use_store = cheboppref('storage');

switch(class(B))
  case 'chebop'
    %TODO: Experimental, undocumented.
    dom = domaincheck(A,B);
    C = chebop( A.varmat\B.varmat, [], dom, B.difforder-A.difforder );  
  case 'chebfun'
    dom = domaincheck(A,B(:,1));
    if A.numbc~=A.difforder
      warning('chebop:mldivide:bcnum',...
        'Operator may not have the correct number of boundary conditions.')
    end
    if isa(A.scale,'chebfun') || isa(A.scale,'function_handle')
      C = chebfun( @(x) A.scale(x)+value(x), dom ) - A.scale;
    else
      C = chebfun( @(x) A.scale+value(x), dom ) - A.scale;
    end
  otherwise
    error('chebop:mtimes:badoperand','Unrecognized operand.')
end

  function v = value(x)
    N = length(x);
    if N > 1025
      error('failure to converge')
    end
    if N <= A.numbc+1
      % Too few points: force refinement
      v = (-1).^(0:N-1)';
      return
    end
    
    % Retrieve or compute LU factors of the matrix.
    if use_store && N > 5 && length(storage)>=A.ID ...
        && length(storage(A.ID).l)>=N && ~isempty(storage(A.ID).l{N})
     l = storage(A.ID).l{N};
     u = storage(A.ID).u{N};
     rowidx = storage(A.ID).rowidx{N};
    else
      [L,c,rowidx] = feval(A,N);  % includes row replacements
      [l,u] = lu(L);
    end
    
    % Modify RHS as needed.
    f = B(x);
    f(rowidx) = c;
     
    % Solve.
    v = u\(l\f);
    
    % Store factors if necessary.
    if use_store && N > 5
      % This is very crude garbage collection! If over capacity, clear out
      % everything.
      ssize = whos('storage');
      if ssize.bytes > cheboppref('maxstorage')
        storage = struct([]); 
      end
      storage(A.ID).l{N} = l;
      storage(A.ID).u{N} = u;
      storage(A.ID).rowidx{N} = rowidx;
    end

    v = filter(v,1e-8);

  end
      
end