function [M,B,c,rowreplace] = feval(A,n,usebc)
% FEVAL  Apply or realize a linop.
% FEVAL(A,U) for chebfun U applies A to U; i.e., it returns A*U.
%
% M = FEVAL(A,N) for integer N returns the matrix associated with A at 
% size N.
%
% [M,B,C,RR] = FEVAL(A,N,'bc') modifies the matrix according to any
% boundary conditions that have been set for A. In particular, M(RR,:)=B,
% and C is a vector of boundary values corresponding to the rows in RR.
%
% FEVAL(A,Inf) returns the functional form of A if it is available.
%
% See also linop/subsref.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.

%  Last commit: $Author$: $Rev$:
%  $Date$:

% For future performance, store realizations.
persistent storage
if isempty(storage), storage = struct([]); end
use_store = true; %cheboppref('storage');

usebc = (nargin > 2) && strcmpi(usebc,'bc');

if isa(n,'chebfun')  % apply to chebfun
  M = A*n;
  return
end

if isinf(n)   % function
  if ~isempty(A.oparray)
    M = A.oparray;
    if A.numbc && usebc > 0
      warning('linop:feval:funbc',...
        'Boundary conditions are not imposed in the functional form.')
    end
  else
    error('linop:feval:nofun',...
      'This operator does not have a functional form defined.')
  end

else          % matrix   
  if use_store && n > 4 && length(storage)>=A.ID ...
      && length(storage(A.ID).mat)>=n && ~isempty(storage(A.ID).mat{n})
    M = storage(A.ID).mat{n};
  else
    M = feval(A.varmat,n);
    if use_store && n > 4
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

