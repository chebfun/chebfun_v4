function [V,D] = eigs(A,k,sigma)

if nargin < 3
  sigma = 0;
  if nargin < 2
    k = 10;
  end
end

% Adaptively construct the kth eigenvalue.
v = chebfun( @(x) A.scale + value(x) ) - A.scale;
% Now we know N.
[W,D] = bc_eig(A,length(v),k,sigma);
V = {};
for j = 1:k
  V{j} = chebfun( @(x) flipud(W(:,j)), length(W)-1 );
end

  function v = value(x)
    N = length(x);
    if N==2
      v = [0;0];
    else
      [V,D] = bc_eig(A,N,k,sigma);
      v = flipud(V(:,end));
      v = filter(v,1e-8);
    end
  end

end

function [V,D] = bc_eig(A,N,k,sigma)
L = feval(A,N);
elim = false(N,1);
cons = A.constraint;
for j = 1:length(cons)
  elim(cons(j).idx(N)) = true;
  L(cons(j).idx(N),:) = cons(j).row(N);
end
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
