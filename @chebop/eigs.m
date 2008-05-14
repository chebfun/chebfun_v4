function varargout = eigs(A,varargin)
% EIGS  Find selected eigenvalues and eigenfunctions of a chebop.
% D = EIGS(A) returns a vector of the chebop A's 6 smallest (in magnitude) 
% eigenvalues. This is unlike the built-in EIGS, which returns the largest
% eigenvalues by default.
%
% [V,D] = EIGS(A) returns a diagonal 6x6 matrix D of A's smallest
% eigenvalues, and a quasimatrix V of the corresponding eigenfunctions.
%
% EIGS(A,B) solves the generalized eigenproblem A*V = B*V*D, where B
% is another chebop. 
%
% EIGS(A,K) and EIGS(A,B,K) find the K smallest eigenvalues. 
%
% EIGS(A,K,SIGMA) and EIGS(A,B,K,SIGMA) find K eigenvalues. If SIGMA is a
% scalar, the eigenvalues found are the ones closest to SIGMA. Other
% possibilities are 'LR' and 'SR' for the eigenvalues of largest and
% smallest real part, and 'LM' (or Inf) for largest magnitude. SIGMA must
% be chosen appropriately for the given operator; for example, 'LM' for an
% unbounded operator will fail to converge!
%
% Despite the syntax, this version of EIGS does not use iterative methods
% as in the built-in EIGS for sparse matrices. Instead, it uses the
% built-in EIG on dense matrices of increasing size, stopping when the Kth
% eigenfunction appears to have converged as determined by chebfun
% construction.
%
% EXAMPLE: Simple harmonic oscillator
%
%   d = domain(0,pi);
%   A = diff(d,2) & 'dirichlet';
%   [V,D]=eigs(A,10);
%   format long, sqrt(-diag(D))  % integers, to 14 digits
%
% See also EIGS, EIG.

% Toby Driscoll, 12 May 2008. 
% Copyright 2008.

% Parsing.
B = [];  k = 6;  sigma = 0;
gotk = false;
j = 1;
while (nargin > j)
  if isa(varargin{j},'chebop')
    B = varargin{j};
  else
    % k must be given before sigma.
    if ~gotk
      k = varargin{j};
      gotk = true;
    else
      sigma = varargin{j};
    end
  end
  j = j+1;
end

% These assignments cause the nested function value() to overwrite them.
V = [];  D = [];
% Adaptively construct the kth eigenfunction.
v = chebfun( @(x) A.scale + value(x) ) - A.scale;

% Now V,D are already defined at the highest value of N used.

if nargout<2
  varargout = { diag(D) };
else
  dom = A.fundomain;
  Vfun = chebfun;
  for j = 1:k
    Vfun(:,j) = chebfun( V(:,j), dom );
    Vfun(:,j) = Vfun(:,j)/norm(Vfun(:,j));
  end
  varargout = { Vfun, D };
end

  % Called by the chebfun constructor. Returns values of the "highest"
  % eigenfunction.
  function v = value(x)
    N = length(x);
    if N-A.numbc < k
      % Not enough eigenvalues. Return a sawtooth to ensure refinement.
      v = (-1).^(0:N-1)';
    else
      [V,D] = bc_eig(A,B,N,k,sigma);
      v = V(:,end);
      v = filter(v,1e-8);
    end
  end


end

% Computes the (discrete) e-vals and e-vecs. 
function [V,D] = bc_eig(A,B,N,k,sigma)
[L,c,rowrep] = feval(A,N);
elim = false(N,1);
elim(rowrep) = true;
if isempty(B)
  % Use algebra with the BCs to remove degrees of freedom.
  R = -L(elim,elim)\L(elim,~elim);  % maps interior to removed values
  L = L(~elim,~elim) + L(~elim,elim)*R;
  [W,D] = eig(full(L));
  idx = nearest(diag(D),sigma,min(k,N));
  V = zeros(N,length(idx));
  V(~elim,:) = W(:,idx);
  V(elim,:) = R*V(~elim,:);
else
  % Use generalized problem to impose the BCs.
  M = feval(B,N);
  M(elim,:) = 0;
  [W,D] = eig(full(L),full(M));
  idx = nearest(diag(D),sigma,min(k,N));
  V = W(:,idx);
end
D = D(idx,idx);
end

% Returns index that sorts eigenvalues/vectors by the given criterion.
function idx = nearest(lam,sigma,k)

if isnumeric(sigma)
  if isinf(sigma) 
    [junk,idx] = sort(abs(lam),'descend');
  else
    [junk,idx] = sort(abs(lam-sigma));
  end
else
  switch upper(sigma)
    case 'LR'
      [junk,idx] = sort(real(lam),'descend');
    case 'SR'
      [junk,idx] = sort(real(lam));
    case 'LM'
      [junk,idx] = sort(abs(lam),'descend');
  end
end

idx = idx( 1:min(k,length(lam)) );  % trim length

end
