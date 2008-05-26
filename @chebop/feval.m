function [M,B,c,rowreplace] = feval(A,n,usebc)
% FEVAL  Realization of a chebop at fixed size.
% M = FEVAL(A,N) for integer N returns the matrix associated with A at 
% size N.
%
% [M,B,C,RR] = FEVAL(A,N,'bc') modifies the matrix according to any
% boundary conditions that have been set for A. In particular, M(RR,:)=B,
% and C is a vector of boundary values corresponding to the rows in RR.
%
% FEVAL(A,Inf) returns the functional form of A if it is available.
%
% See also chebop/subsref.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

% For future performance, store realizations.
persistent storage
if isempty(storage), storage = struct([]); end
use_store = cheboppref('storage');

usebc = (nargin > 2) && strcmpi(usebc,'bc');

if isinf(n)   % function
  if ~isempty(A.oper)
    M = A.oper;
    if A.numbc && usebc > 0
      warning('chebop:feval:funbc',...
        'Boundary conditions are not imposed in the functional form.')
    end
  else
    error('chebop:feval:nofun',...
      'This operator does not have a functional form defined.')
  end

else          % matrix   
  if use_store && n > 10 && length(storage)>=A.ID ...
      && length(storage(A.ID).mat)>=n && ~isempty(storage(A.ID).mat{n})
    M = storage(A.ID).mat{n};
  else
    M = feval(A.varmat,n);
    if use_store && n > 10
      % This is very crude garbage collection! If size is exceeded, wipe
      % out everything.
      ssize = whos('storage');
      if ssize.bytes > cheboppref('maxstorage')
        storage = struct([]); 
      end
      storage(A.ID).mat{n} = M;
    end 
  end
  
  if usebc
    [B,c,rowreplace] = bdyreplace(A,n);
    M(rowreplace,:) = B;
  end
end

