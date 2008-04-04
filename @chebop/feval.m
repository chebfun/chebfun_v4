function [M,rowreplace] = feval(A,n)

rowreplace = [];
persistent storage
if isempty(storage), storage = struct([]); end
use_store = cheboppref('storage');

if isinf(n)
  if A.validoper
    M = A.oper;
    if numbc(A) > 0
      warning('chebop:feval:funbc',...
        'Boundary conditions are not imposed in the functional form.')
    end
  else
    error('chebop:feval:nofun',...
      'This operator does not have a functional form defined.')
  end
else
  if use_store && n > 100 && length(storage)>=A.ID ...
      && length(storage(A.ID).mat)>=n && ~isempty(storage(A.ID).mat{n})
    M = storage(A.ID).mat{n};
    rowreplace = storage(A.ID).rowreplace{n};
    %fprintf('  using stored matrix\n')
  else
    M = feval(A.varmat,n);
    for k = 1:length(A.lbc)
      op = A.lbc(k).op;
      if ~isempty(op)
        B = feval(op,n);
        M(k,:) = B(1,:);
        rowreplace(end+1) = k;
      end
    end
    for k = 1:length(A.rbc)
      op = A.rbc(k).op;
      if ~isempty(op)
        B = feval(op,n);
        M(n+1-k,:) = B(end,:);
        rowreplace(end+1) = n+1-k;
      end
    end
    if use_store && n > 100
      % This is very crude garbage collection!
      ssize = whos('storage');
      if ssize.bytes > cheboppref('maxstorage')
        storage = struct([]); 
      end
      storage(A.ID).mat{n} = M;
      storage(A.ID).rowreplace{n} = rowreplace;
    end 
  end
end

