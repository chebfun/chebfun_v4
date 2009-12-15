function varargout = eigs(A,varargin)
% EIGS  Find selected eigenvalues and eigenfunctions of a linop.
% D = EIGS(A) returns a vector of 6 eigenvalues of the linop A. EIGS will
% attempt to return the eigenvalues corresponding to the least oscillatory
% eigenfunctions. (This is unlike the built-in EIGS, which returns the 
% largest eigenvalues by default.)
%
% [V,D] = EIGS(A) returns a diagonal 6x6 matrix D of A's least oscillatory
% eigenvalues, and a quasimatrix V of the corresponding eigenfunctions.
%
% EIGS(A,B) solves the generalized eigenproblem A*V = B*V*D, where B
% is another linop. 
%
% EIGS(A,K) and EIGS(A,B,K) find the K smoothest eigenvalues. 
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
% built-in EIG on dense matrices of increasing size, stopping when the 
% targeted eigenfunctions appear to have converged, as determined by the
% chebfun constructor.
%
% EXAMPLE: Simple harmonic oscillator
%
%   d = domain(0,pi);
%   A = diff(d,2) & 'dirichlet';
%   [V,D]=eigs(A,10);
%   format long, sqrt(-diag(D))  % integers, to 14 digits
%
% See also EIGS, EIG.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.

%  Last commit: $Author$: $Rev$:
%  $Date$:

% Parsing.
B = [];  k = 6;  sigma = [];
gotk = false;
j = 1;
while (nargin > j)
  if isa(varargin{j},'linop')
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

maxdegree = cheboppref('maxdegree');
m = A.blocksize(2);
if m~=A.blocksize(1)
  error('LINOP:eigs:notsquare','Block size must be square.')
end

if isempty(sigma)
  % Try to determine where the 'most interesting' eigenvalue is.
  [V1,D1] = bc_eig(A,B,33,33,0);
  [V2,D2] = bc_eig(A,B,65,65,0);
  lam1 = diag(D1);  lam2 = diag(D2);
  dif = repmat(lam1.',length(lam2),1) - repmat(lam2,1,length(lam1));
  delta = min( abs(dif) );   % diffs from 33->65
  bigdel = (delta > 1e-12*norm(lam1,Inf));
  if all(bigdel) 
    % All values changed somewhat--choose the one changing the least.
    [tmp,idx] = min(delta);
    sigma = lam1(idx);
  else
    % Of those that did not change much, take the smallest cheb coeff
    % vector. 
    lam1(bigdel) = [];
    V1 = reshape( V1, [33,m,size(V1,2)] );  % [x,varnum,modenum]
    V1(:,:,bigdel) = [];
    V1 = permute(V1,[1 3 2]);       % [x,modenum,varnum]
    C = zeros(size(V1));
    for j = 1:size(C,3)  % fpr each variable
      C(:,:,j) = abs( cd2cp(V1(:,:,j)) );  % cheb coeffs of all modes
    end
    mx = max( max(C,[],1), [], 3 );  % max for each mode over all vars
    [cmin,idx] = min( sum(sum(C,1),3)./mx );  % min 1-norm of each mode
    sigma = lam1(idx);
  end
end

% These assignments cause the nested function value() to overwrite them.
V = [];  D = [];
% Adaptively construct the sum of eigenfunctions.
v = chebfun( @(x) A.scale + value(x), chebopdefaults) - A.scale;

% Now V,D are already defined at the highest value of N used.

if nargout<2
  varargout = { diag(D) };
else
  dom = A.fundomain;
  V = reshape( V, [N,m,k] );
  Vfun = {}; 
  for j = 1:k
    nrm2 = 0;
    for i = 1:m
      f = chebfun( V(:,i,j), dom, chebopdefaults);
      % This line is needed to simplify/compress the chebfuns.
      f = chebfun( @(x) f(x), dom, chebopdefaults);
      Vfun{i}(:,j) = f;  nrm2 = nrm2 + norm(f)^2;
    end
    % Normalization
    for i = 1:m
      Vfun{i}(:,j) = Vfun{i}(:,j)/sqrt(nrm2);
    end
  end
  if m==1, Vfun = Vfun{1}; end
  varargout = { Vfun, D };
end

  % Called by the chebfun constructor. Returns values of the sum of the
  % "interesting" eigenfunctions. 
  function v = value(x)
    N = length(x);
    if N > maxdegree+1
      msg = sprintf(...
        'No convergence with %i points. Check sigma, or ask for fewer modes.',...
        maxdegree+1);
      error('LINOP:eigs:NoConverge',msg)
    end
    if N-A.numbc < k
      % Not enough eigenvalues. Return a sawtooth to ensure refinement.
      v = ones(N,1); 
      v(2:2:end) = -1;
    else
      [V,D] = bc_eig(A,B,N,k,sigma);
      v = sum( sum( reshape(V,[N,m,k]),2), 3);
      v = filter(v,1e-8);
    end
  end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [V,D] = bc_eig(A,B,N,k,sigma)
% Computes the (discrete) e-vals and e-vecs. 

m = A.blocksize(1);
% Instantiate A, with row replacements.
L = feval(A,N);
[Abdy,c,rowrep] = bdyreplace(A,N);
L(rowrep,:) = Abdy;
elim = false(N*m,1);
elim(rowrep) = true;
if isempty(B)
  % Use algebra with the BCs to remove degrees of freedom.
  R = -L(elim,elim)\L(elim,~elim);  % maps interior to removed values
  L = L(~elim,~elim) + L(~elim,elim)*R;
  [W,D] = eig(full(L));
  idx = nearest(diag(D),sigma,min(k,N));
  V = zeros(N*m,length(idx));
  V(~elim,:) = W(:,idx);
  V(elim,:) = R*V(~elim,:);
else
  % Use generalized problem to impose the BCs.
  M = feval(B,N);
  %FIXME: Kludge when B is given BCs. We have to assume that these are 
  % given in the same order as they are in A. I can't see any way to check 
  % up on this. 
  Bbdy = bdyreplace(B,N);
  nla = length(A.lbc);  nra = length(A.rbc);
  nlb = length(B.lbc);  nrb = length(B.rbc);
  Brows = rowrep( [1:nlb, nla+(1:nrb)] );
  M(Brows,:) = Bbdy;
  % For rows of B that were not replaced, default to zero rows.
  elim(Brows) = false;
  M(elim,:) = 0;
  [W,D] = eig(full(L),full(M));
  % We created some infinite eigenvalues. Peel them off. 
  [lam,idx] = sort( abs(diag(D)),'descend' );
  idx = idx(1:sum(elim));
  D(:,idx) = [];  D(idx,:) = [];  W(:,idx) = [];
  idx = nearest(diag(D),sigma,min(k,N));
  V = W(:,idx);
end
D = D(idx,idx);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns index vector that sorts eigenvalues by the given criterion.
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

% Delete infinite values. These can arise from rank deficiencies in the 
% RHS matrix of the generalized eigenproblem.
idx( ~isfinite(lam(idx)) ) = [];

% Return the first k, if more are available.
idx = idx( 1:min(k,length(idx)) );  

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = cd2cp(y)
%CD2CP  Chebyshev discretization to Chebyshev polynomials (by FFT).
%   P = CD2CP(Y) converts a vector of values at the Chebyshev extreme
%   points to the coefficients (ascending order) of the interpolating
%   Chebyshev expansion.  If Y is a matrix, the conversion is done
%   columnwise.

p = zeros(size(y));
if any(size(y)==1), y = y(:); end
N = size(y,1)-1;

yhat = fft([y(N+1:-1:1,:);y(2:N,:)])/(2*N);

p(2:N,:) = 2*yhat(2:N,:);
p([1,N+1],:) = yhat([1,N+1],:);

if isreal(y),  p = real(p);  end

end
