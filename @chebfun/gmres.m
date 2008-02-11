function [u,normres,Q] = gmres(varargin)

% GMRES Iterative method for chebfun operator equations.
%
% U = GMRES(A,F) attempts to solve the operator equation L(U)=F, where F is
% a chebfun and L is an operator (e.g., anonymous function) on chebfuns.
%
% U = GMRES(A,F,RESTART) chooses a restart parameter. Use Inf or [] for no
% restarts. The default is Inf.
%
% U = GMRES(A,F,RESTART,TOL) tries to find a solution for which the
% residual norm is less than TOL relative to the norm of F. The default
% value is 1e-10.
%
% U = GMRES(A,F,RESTART,TOL,MAXIT) stops after MAXIT total iterations. This
% defaults to 36.
%
% U = GMRES(A,F,RESTART,TOL,MAXIT,M1INV,M2INV) applies the left and right
% preconditioners M1INV and M2INV, defined as operators. They should
% approximate the *inverse* of L.
%
% [U,NORMRES] = GMRES(A,F,...) also returns a vector of the relative
% residual norms for all iterations. 
%
% Note the output ordering is not the same as for builtin GMRES...
%
% See also GMRES.
%
% EXAMPLE
%
%   % To solve a simple Volterra integral equation:
%   f = chebfun('exp(-4*x.^2)');
%   L = @(u) cumsum(u) + 20*u;
%   u = gmres(L,f,Inf,1e-14);

% Toby Driscoll, 11 February 2008.

% There are still some optimization possibilities. Stable quasimatrices
% will make some syntax simpler. May want to suppress progress output, or
% do something more elegant.

% Parse inputs and supply defaults.
defaults = {[],[],Inf,1e-10,36,[],[]};
idx = nargin+1:length(defaults);
args = [varargin defaults(idx)];
[L,f,m,tol,maxiter,M1inv,M2inv] = deal( args{:} );

if m==0, m = Inf; end;                           % no restarts

u = chebfun('0',domain(f));
normb = norm(f);
r = f;

if ~isempty(M1inv), r=M1inv(r); end
normres(1) = norm(r)/normb;
j = 1;                                           % total iterations
while (normres(j) > tol) && (j<maxiter)
  H = [];
  QTb = norm(r);
  Q = { r/QTb };                                 % Krylov basis
  for n = 1:m
    % Next Krylov vector, with preconditioners.
    q = Q{n};                                    
    if ~isempty(M2inv), q = M2inv(q); end       
    v = L( q );                                   
    if ~isempty(M1inv), v = M1inv(v); end       
    % Modified Gram-Schmidt iteration.
    for k = 1:n                     
      H(k,n) = sum( conj(Q{k}).*v );             
      v = v - H(k,n)*Q{k};                        
    end 
    H(n+1,n) = norm(v);                          
    Q{n+1} = v / H(n+1,n);                       % new basis vector
    
    % Use QR factorization to find the residual norm.
    QTb(n+1,1) = 0;                              % by orthogonality
    j = j + 1;
    [P,R] = qr(H);  
    normres(j) = abs(P(1,n+1)*QTb(1))/normb;
    
    % Done?
    if normres(j) < tol, break, end;
    
    % Output?
    if rem(j-1,2)==0
      fprintf('Iteration %2i: relative residual norm = %.3e\n',...
        j-1,normres(j));
    end
    
    % Give up?
    if j==maxiter+1
      warning('chebfun:gmres:maxiter','Max number of iterations reached.')
      break
    end
    
    % Reorthogonalize (not yet a formal option).
    if rem(n,Inf)==0
      % Re-orthogonalize
      Z = {};
      for k = 1:n+1
        Z{k} = Q{k}/norm(Q{k});
        for i = k+1:n+1
          Q{i} = Q{i} - sum(conj(Z{k}).*Q{i})*Z{k};
        end
      end
    end
      
  end   % inner iterations
  
  y = R(1:n,1:n)\(P(:,1:n)'*QTb);                % least squares soln
  u0 = lincombine(Q,y);                          % new part of solution
  if ~isempty(M2inv), u0=M2inv(u0); end
  u = u + u0;                                    % solution
  v = L(u0);
  if ~isempty(M1inv), v = M1inv(v); end
  r = r - v;                                     % new residual
end   % outer iterations

fprintf('Final relative residual: %.3e\n\n',normres(end))

end   % main function


function u = lincombine(Q,y)
  u = 0;
  for k = 1:length(y)
    u = u + y(k)*Q{k};
  end
end
