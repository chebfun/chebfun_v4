function varargout = eigs(A,varargin)

B = [];  k = 6;  sigma = 0;
gotk = false;
j = 1;
while (nargin > j)
  if isa(varargin{j},'chebop')
    B = varargin{j};
  else
    if ~gotk
      k = varargin{j};
      gotk = true;
    else
      sigma = varargin{j};
    end
  end
  j = j+1;
end

if ischar(sigma), sigma = upper(sigma); end

% Adaptively construct the kth eigenvalue.
v = chebfun( @(x) A.scale + value(x) ) - A.scale;
% Now we know N.
[W,D] = bc_eig(A,B,length(v),k,sigma);

if nargout<2
  varargout = { diag(D) };
else
  dom = A.fundomain;
  V = chebfun;
  for j = 1:k
    V(:,j) = chebfun( W(:,j), dom );
    V(:,j) = V(:,j)/norm(V(:,j));
  end
  varargout = { V, D };
end

  function v = value(x)
    N = length(x);
    if N-A.numbc < k
      % There won't be enough eigenvalues. Return a sawtooth to ensure
      % further refinement.
      v = (-1).^(0:N-1)';
    else
      [V,D] = bc_eig(A,B,N,k,sigma);
      v = V(:,end);
      v = filter(v,1e-8);
    end
  end

end

function [V,D] = bc_eig(A,B,N,k,sigma)
[L,rowrep] = feval(A,N);
elim = false(N,1); 
elim(rowrep) = true;
if isempty(B)
  R = -L(elim,elim)\L(elim,~elim);  % maps interior to removed values
  L = L(~elim,~elim) + L(~elim,elim)*R;
  [W,D] = eig(full(L));
  idx = nearest(diag(D),sigma,min(k,N));
  V = zeros(N,length(idx));
  V(~elim,:) = W(:,idx);
  V(elim,:) = R*V(~elim,:);
else
  M = feval(B,N);
  M(elim,:) = 0;
  [W,D] = eig(full(L),full(M));
  idx = nearest(diag(D),sigma,min(k,N));
  V = W(:,idx);
end  
D = D(idx,idx);
end

function idx = nearest(lam,sigma,k)
if isequal(sigma,'LR')
  [junk,idx] = sort(real(lam),'descend');
elseif isequal(sigma,'SR')
  [junk,idx] = sort(real(lam));
elseif isinf(sigma)
  [junk,idx] = sort(abs(lam),'descend');
else
  [junk,idx] = sort(abs(lam-sigma));
end
idx = idx( 1:min(k,length(lam)) );
end
