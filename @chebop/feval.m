function [M,rowreplace] = feval(A,n)

rowreplace = [];

if isinf(n)
  if A.validoper
    M = A.oper;
    if ~isempty(A.lbc) || ~isempty(A.rbc)
      warning('chebop:feval:funbc',...
        'Boundary conditions are not imposed in the functional form.')
    end
  else
    error('chebop:feval:nofun',...
      'This operator does not have a functional form defined.')
  end
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
  
    
end

