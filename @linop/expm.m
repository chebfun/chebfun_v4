function E = expm(A)
% EXPM   Exponential of a linop.
% E = EXPM(A) returns a linop representing the exponential operator
% generated by A. The linop A should have boundary conditions appropriate
% for its definition, or else usage of E may be nonconvergent or
% unexpected. 
%
% Note that operations on linops clear out boundary conditions, so you
% must reassign them before calling EXPM. Homogeneous (zero) boundary
% values are used, even if they are specified otherwise.
%
% EXAMPLE: Heat equation
% d = domain(-1,1);  x = chebfun('x',d);
% D = diff(d);  A = D^2;  bc = 'dirichlet';
% f = exp(-20*(x+0.3).^2);
% clf, plot(f,'r'), hold on, c = [0.8 0 0];
% for t = [0.001 0.01 0.1 0.5 1]
%    E = expm(t*A & bc);
%    plot(E*f,'color',c),  c = 0.5*c;
%  end
%
% See also EXPM, CHEBOP/AND, CHEBOP/SUBSASGN.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008-2009 by Toby Driscoll.

%  Last commit: $Author$: $Rev$:
%  $Date$:


maxdegree = cheboppref('maxdegree');

% Check for warnings/errors.
[L,B,c,rowrep] = feval(A,10,'oldschool');
if any(c~=0)
  warning('LINOP:expm:boundarydata',...
    'Ignoring nonzero boundary data--setting to zero.')
end

if all(A.blocksize==[1 1]) && (A.numbc~=A.difforder)
  warning('LINOP:expm:bc',...
    'Operator may not have the right number of boundary conditions.')
end

m = A.blocksize(2);
if m~=A.blocksize(1)
  error('LINOP:expm:square','Operator must be block-square.')
end

% We need two versions of the linop. The returned version inspects the
% initial data using the operator form. The internal version does not have
% an operator form, so that mtimes will iteratively apply the matrix until
% chebfun happiness.

E = linop( @expm_mat, @expm_op, domain(A), 0);
E.blocksize = [m m];
F = linop( @expm_mat, [], domain(A), 0);
F.blocksize = [m m];


  function E = expm_mat(n)
    in = n;
    breaks = []; map = [];
    if iscell(n)
        if numel(n) > 1, map = n{2}; end
        if numel(n) > 2, breaks = n{3}; end
        n = n{1};
    end
      
    % Function may be called with n=2. Punt.
    if A.numbc >= n
      E = eye(n*m);
      return
    end
    if n > maxdegree+1
      msg = sprintf('Failed to converge with %i points.',maxdegree+1);
      error('LINOP:expm:NoConverge',msg)
    end

    [L,B,c,rowrep] = feval(A,n,'oldschool',map,breaks);
    elim = false(n*m,1);  elim(rowrep) = true;
    % Use algebra with the BCs to remove degrees of freedom.
    R = -L(elim,elim)\L(elim,~elim);  % maps interior to removed values
    L = L(~elim,~elim) + L(~elim,elim)*R;  % reduced to interior DOF

    E1 = expm(L);

    % Return to full-size operator.
    E = zeros(n*m);
    E(~elim,~elim) = E1;
    E(elim,~elim) = R*E1;
  end

  function v = expm_op(u)
    ms = chebfunpref('minsamples');   % save for later
    if isinf(size(u,2)), u = u.'; end

    % Determine min sampling size based on initial data.
    n = ms;
    for j = 1:size(u,2)
      if length(u(:,j).ends) > 2
        warning('LINOP:expm:Nonsmooth',...
          'Nonsmooth initial data may degrade accuracy in the result.')
      else
        n = max(n,length(u(:,j)));
      end
    end
    
    % Use mtimes on the matrix definition.
    chebfunpref('minsamples',n)
    v = F*u;
    chebfunpref('minsamples',ms)
  end
end