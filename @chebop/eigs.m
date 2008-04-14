function varargout = eigs(A,k,sigma)

if nargin < 3
  sigma = 0;
  if nargin < 2
    k = 6;
  end
end

nbc = numbc(A);

% Adaptively construct the kth eigenvalue.
v = chebfun( @(x) A.scale + value(x) ) - A.scale;
% Now we know N.
[W,D] = bc_eig(A,length(v),k,sigma);

if nargout<2
  varargout = { diag(D) };
else
  V = {};
  dom = A.fundomain;
  for j = 1:k
    V{j} = chebfun( @(x) flipud(W(:,j)), length(W)-1 );
    V{j}{dom(1),dom(2)} = V{j};
    V{j} = V{j}(dom);
    V{j} = V{j}/norm(V{j});
  end
  varargout = { V, D };
end

  function v = value(x)
    N = length(x);
    if N-nbc < k
      % There won't be enough eigenvalues. Return a sawtooth to ensure
      % further refinement.
      v = (-1).^(0:N-1)';
    else
      [V,D] = bc_eig(A,N,k,sigma);
      v = flipud(V(:,end));
      v = filter(v,1e-8);
    end
  end

end

function [V,D] = bc_eig(A,N,k,sigma)
[L,rowrep] = feval(A,N);
elim = false(N,1); 
elim(rowrep) = true;
B = -L(elim,elim)\L(elim,~elim);  % maps interior to removed values
L = L(~elim,~elim) + L(~elim,elim)*B;
[W,D] = eig(L);
idx = nearest(diag(D),sigma,min(k,N));
V = zeros(N,length(idx));
V(~elim,:) = W(:,idx);
V(elim,:) = B*V(~elim,:);
D = D(idx,idx);
end

function idx = nearest(lam,sigma,k)
if isinf(sigma)
  [junk,idx] = sort(abs(lam),'descend');
else
  [junk,idx] = sort(abs(lam-sigma));
end
idx = idx( 1:min(k,length(lam)) );
end
