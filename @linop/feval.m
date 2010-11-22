function [M,B,c,rowreplace,P] = feval(A,n,usebc,map,breaks)
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
use_store = cheboppref('storage');
use_store = false;

if isa(n,'chebfun')  % Apply to chebfun
  M = A*n;
  return
end

% Parse the inputs.
if nargin < 5, breaks = []; end
if nargin < 4, map = []; end
if nargin > 2 
    if isstruct(usebc) || isa(usebc,'function_handle') || isempty(usebc)    
        if ~isstruct(map)
            if nargin == 4, breaks = map; end
            if nargin < 5,  map = usebc;  end
        end
        usebc = 0;
    elseif nargin == 3 && ((isnumeric(usebc) && numel(usebc) > 1) || isa(usebc,'domain'))
        breaks = usebc; map = []; usebc = 0;
    else
        usebc = .5*strcmpi(usebc,'rect') + 1.0*strcmpi(usebc,'bc') + 1.5*strcmpi(usebc,'oldschool');
    end
else
    usebc = 0;
end
if nargin < 5 && ~isempty(map) && (isnumeric(map) || isa(map,'domain'))
    breaks = map;
    map = [];
end

% usebc = 0 --> No boundary conditions
% usebc = 0.5 ('rect') --> Compute the projection, but don't add BCs
% usebc = 1 ('bc') --> Compute projections and apply boundary conditions
% usebc = 1.5 ('oldschool') --> Use row replacement rather than rectangular matrices

% Initialise output variables
M = []; B = []; c = []; rowreplace = []; P = [];

% Sort out the breaks
if isa(breaks,'domain'), breaks = breaks.endsandbreaks; end
breaks = sort(breaks);
if ~isempty(breaks) && (breaks(1) < A.fundomain(1) || breaks(end) > A.fundomain(end))
    error('CHEBFUN:linop:breaksdomain','Breaks must be within domain of linop');
end
breaks = union(breaks,A.fundomain.endsandbreaks);

% We set trivial maps and breaks to empty
if numel(breaks) == 2 && ~any(isempty(breaks)), breaks = []; end
if isstruct(map) && strcmp(map(1).name,'linear'), map = []; end

% We don't use storage if there's a nontrivial map 
if ~isempty(map), use_store = 0; end
% Nor if numel(n) > 1
if numel(n) > 1, use_store = 0; end
% Or if we have a non-trivial domain
if ~isempty(breaks), use_store = 0; end

% Repeat N if the use has been lazy
if numel(n) == 1 && ~isempty(breaks)
  n = repmat(n,1,numel(breaks)-1);
end

% Force maps for unbounded domains
if isempty(map) && any(isinf(breaks))
    map = cell(numel(breaks)-1,1);
    for k = 1:numel(breaks)-1;
        map{k} = maps(domain(breaks(k:k+1)));
    end
end
  
% %%%%%%%%%% function (i,e., infinite dimensional operator) %%%%%%
if any(isinf(n))  
  if ~isempty(A.oparray)
    M = A.oparray;
    if A.numbc && usebc > 0
      warning('LINOP:feval:funbc',...
        'Boundary conditions are not imposed in the functional form.')
    end
  else
    error('LINOP:feval:nofun',...
      'This operator does not have a functional form defined.')
  end

else
% %%%%%%%%%%%%%%%%%%%% matrix representation %%%%%%%%%%%%%%%%%%%%%
  % Is the matrix already exists in storage?
  if use_store && n > 4 && length(storage)>=A.ID ...
      && length(storage(A.ID).mat)>=n && ~isempty(storage(A.ID).mat{n})
    M = storage(A.ID).mat{n};
  else % If not,m then make it.
    M = feval(A.varmat,{n,map,breaks});
    if use_store && n > 4
      % This is very crude garbage collection! 
      % If size is exceeded, wipe out everything.
      ssize = whos('storage');
      if ssize.bytes > cheboppref('maxstorage')
        storage = struct([]); 
      end
      storage(A.ID).mat{n} = M;
    end 
  end
  
% %%%%%%%%%%%%%%%%%%%%%% Boundary conditions %%%%%%%%%%%%%%%%%%%%%%

  % No boundary conditions
  if ~usebc, return, end
  
  % Oldschool rowreplacement
  if usebc == 1.5
      if ~isempty(breaks)
          % We force rectangular matrices in this case.
          warning('CHEBFUN:linop:feval:oldschool', ...
              'oldschool does not support piecewise linops.');
      else
          [B,c,rowreplace] = bdyreplace(A,n,map,breaks);
          M(rowreplace,:) = B;
          return
      end
  end

  % Rectangular matrices and boundary conditions
  if max(A.blocksize) == 1  % Single equation
      if isempty(breaks)     % No breakpoints
          % Project
%           P = barymatp(n-A.difforder,breaks,n,breaks);
          P = barymatp12(n-A.difforder,[-1 1],n,[-1 1]);
          M = P*M;
          % Compute boundary conditions and apply (if required)
          if usebc == 1
              [B,c] = bdyreplace(A,n,map,breaks);
              rowreplace = sum(n)-(size(B,1)-1:-1:0);
              M = [M ; B];
          end
      else                   % Break points
          % Project
%           P = barymatp(n-A.difforder,breaks,n,breaks);
          P = barymatp12(n-A.difforder,breaks,n,breaks);
          M = P*M;
          % Compute boundary conditions and apply (if required)
          if usebc == 1
              [B c1] = bdyreplace_sys(A,{n},map,{breaks});
              [C c2] = cont_conds_sys(A,{n},map,{breaks});
              B = [B ; C];  M = [M ; B]; c = [c1 ; c2];
              rowreplace = sum(n)-(size(B,1)-1:-1:0);
          end
      end
  else                     % System of equations
      % Project
      MM = []; sn = sum(n);
      do = max(A.difforder); % Max difforder for each equation
      sizeM = A.blocksize(1)*sn; 
      nbc = sizeM;
      P = cell(A.blocksize(1),1);
      for k = 1:A.blocksize(1)
          nk = n-do(k);
          if any(nk<1), error('CHEBFUN:linop:feval:fevalsize', ...
                  'feval size is not large enough for linop.difforder.');
          end
%           Pk = barymatp(nk,breaks,n,breaks);
          if isempty(breaks)
              Pk = barymatp12(nk,[-1 1],n,[-1 1]);
          else
              Pk = barymatp12(nk,breaks,n,breaks);
          end
          ii = ((k-1)*sn+1):k*sn;
          MM = [MM ; Pk*M(ii,:)];
          if nargout == 5, P{k} = Pk; end % Store P
          nbc = nbc - sum(nk);
      end

%       Pmat = zeros(sum(n)*A.blocksize(1));
%       i1 = 0; i2 = 0;
%       for j = 1:A.blocksize(1)
%           ii1 = i1+(1:size(P{j},1));
%           ii2 = i2+(1:size(P{j},2));
%           Pmat(ii1,ii2) = P{j};
%           i1 = ii1(end); i2 = ii2(end);
%       end   
      
      M = MM;
      % Compute boundary conditions and apply
      if usebc == 1
          breaks = repmat({breaks},1,A.blocksize(2));
          n = repmat({n},1,A.blocksize(2));
          [B c1] = bdyreplace_sys(A,n,map,breaks);
          [C c2] = cont_conds_sys(A,n,map,breaks);
          B = [B ; C]; M = [M ; B]; c = [c1 ; c2];
          rowreplace = sizeM-nbc+(1:nbc);          
      end
  end

end


