function [M,c,rowreplace] = feval(A,n)
% FEVAL  Realization of a chebop at fixed size.
% FEVAL(A,N) for integer N returns the matrix associated with A at size N. 
% If boundary conditions are specified for A, they modify rows of this
% matrix accordingly. 
%
% FEVAL(A,Inf) returns the functional form of A if it is available.
%
% [MAT,C,ROWREP] = FEVAL(A,N) returns the matrix MAT, plus a vector C of
% boundary value data and an index vector ROWREP showing which rows of the
% matrix were overwritten with boundary information.
%
% See also CHEBOP/AND, CHEBOP/MLDIVIDE.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

rowreplace = [];

% For future performance, store realizations.
persistent storage
if isempty(storage), storage = struct([]); end
use_store = cheboppref('storage');

if isinf(n)   % function
  if A.validoper
    M = A.oper;
    if A.numbc > 0
      warning('chebop:feval:funbc',...
        'Boundary conditions are not imposed in the functional form.')
    end
  else
    error('chebop:feval:nofun',...
      'This operator does not have a functional form defined.')
  end
else          % matrix   
  if use_store && n > 100 && length(storage)>=A.ID ...
      && length(storage(A.ID).mat)>=n && ~isempty(storage(A.ID).mat{n})
    M = storage(A.ID).mat{n};
    c = storage(A.ID).bc{n};
    rowreplace = storage(A.ID).rowreplace{n};
  else
    M = feval(A.varmat,n);
    [B,c,rowreplace] = bdyreplace(A,n);
    M(rowreplace,:) = B;
    if use_store && n > 100
      % This is very crude garbage collection! If size is exceeded, wipe
      % out everything.
      ssize = whos('storage');
      if ssize.bytes > cheboppref('maxstorage')
        storage = struct([]); 
      end
      storage(A.ID).mat{n} = M;
      storage(A.ID).bc{n} = c;
      storage(A.ID).rowreplace{n} = rowreplace;
    end 
  end
end

