function C = mtimes(A,B)
% *   Compose oparrays or scalar multiply.

% c*A or A*c multiplies the oparray A by scalar c.
% A*B is the oparray that represents the composition of A and B.

% Copyright 2008 by Toby Driscoll. See www.comlab.ox.ac.uk/chebfun.

if isempty(A) || isempty(B)
  C = oparray({});
  return
end

if isnumeric(A)
  C = A; A = B; B = C;
end

if isnumeric(B)   % scalar multiply
  op = cellfun( @(op) @(u) B*op(u), A.op, 'uniform',false );
  C = oparray(op);

else              % compose
  if size(A.op,2)~=size(B.op,1)
    error('oparray:mtimes:size','Inner dimensions do not agree.')
  end

  % Emulate matrix * matrix.
  m = size(A.op,1);  n = size(B.op,2);  q = size(A.op,2);
  op = cell(m,n);
  for i = 1:m
    for j = 1:n
      % Tricky: For nested function, must lock in values of i,j.
      op{i,j} = @(u) innersum(u,i,j);
    end
  end
  C = oparray(op);
end

  function v = innersum(u,i,j)
    v = chebfun(0,domain(u));
    for k = 1:q
      v = v + A.op{i,k}( B.op{k,j}(u) );
    end
  end

end