function varargout = eigs(A,varargin)
% EIGS  Find selected eigenvalues and eigenfunctions of a linop.
% D = EIGS(A) returns a vector of 6 eigenvalues of the linop A. EIGS will
% attempt to return the eigenvalues corresponding to the least oscillatory
% eigenfunctions. (This is unlike the built-in EIGS, which returns the 
% largest eigenvalues by default.)
%
% [V,D] = EIGS(A) returns a diagonal 6x6 matrix D of A's least oscillatory
% eigenvalues, and a quasimatrix V of the corresponding eigenfunctions.
%
% EIGS(A,B) solves the generalized eigenproblem A*V = B*V*D, where B
% is another linop. 
%
% EIGS(A,K) and EIGS(A,B,K) find the K smoothest eigenvalues. 
%
% EIGS(A,K,SIGMA) and EIGS(A,B,K,SIGMA) find K eigenvalues. If SIGMA is a
% scalar, the eigenvalues found are the ones closest to SIGMA. Other
% selection possibilities for SIGMA are:
%    'LM' (or Inf) and 'SM' for largest and smallest magnitude
%    'LR' and 'SR' for largest and smallest real part
%    'LI' and 'SI' for largest and smallest imaginary part
% SIGMA must be chosen appropriately for the given operator. For
% example, 'LM' for an unbounded operator will fail to converge.
%
% Despite the syntax, this version of EIGS does not use iterative methods
% as in the built-in EIGS for sparse matrices. Instead, it uses the
% built-in EIG on dense matrices of increasing size, stopping when the 
% targeted eigenfunctions appear to have converged, as determined by the
% chebfun constructor.
%
% EXAMPLE: Simple harmonic oscillator
%
%   d = domain(0,pi);
%   A = diff(d,2) & 'dirichlet';
%   [V,D] = eigs(A,10);
%   format long, sqrt(-diag(D))  % integers, to 14 digits
%
% See also EIGS, EIG.
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2008 by Toby Driscoll.

%  Last commit: $Author$: $Rev$:
%  $Date$:

% Parsing.
B = [];  k = 6;  sigma = []; map = []; breaks = [];
gotk = false;
j = 1;
while (nargin > j)
  if isa(varargin{j},'linop')
    B = varargin{j};
  elseif isstruct(varargin{j}) && isfield(varargin{j},'name')
      if ~strcmp(varargin{j}.name,'linear')
        map = varargin{j};
      end
  else
    % k must be given before sigma.
    if ~gotk
      k = varargin{j};
      gotk = true;
    else
      sigma = varargin{j};
    end
  end
  j = j+1;
end

maxdegree = cheboppref('maxdegree');
m = A.blocksize(2);
if m~=A.blocksize(1)
  error('LINOP:eigs:notsquare','Block size must be square.')
end

domA = A.fundomain;
if ~isempty(B)
    domB = B.fundomain;
    dom = union(domA,domB);
    A.fundomain = dom;
    B.fundomain = dom;
else
    dom = domA;
end
breaks = dom.endsandbreaks;
numints = numel(breaks)-1;

if isempty(sigma)
  % Try to determine where the 'most interesting' eigenvalue is.
  if numel(breaks) == 2    
      [V1,D1] = bc_eig(A,B,33,33,0,map,breaks);
      [V2,D2] = bc_eig(A,B,65,65,0,map,breaks);
  else
      [V1,D1] = bc_eig_sys(A,B,33,33,0,map,breaks);
      [V2,D2] = bc_eig_sys(A,B,65,65,0,map,breaks);
  end
  lam1 = diag(D1);  lam2 = diag(D2);
  dif = repmat(lam1.',length(lam2),1) - repmat(lam2,1,length(lam1));
  delta = min( abs(dif) );   % diffs from 33->65
  bigdel = (delta > 1e-12*norm(lam1,Inf));
  
  % Trim off things that are still changing a lot (relative to new size).
  lam1b = lam1; lam1b(bigdel) = 0;
  bigdel = logical((delta > 1e-3*norm(lam1b,Inf)) + bigdel);
  
  if all(bigdel)
    % All values changed somewhat--choose the one changing the least.
    [tmp,idx] = min(delta);
    sigma = lam1(idx);
  elseif numel(breaks) == 2 % Smooth
        % Of those that did not change much, take the smallest cheb coeff
        % vector. 
        lam1(bigdel) = [];
        V1 = reshape( V1, [33,m,size(V1,2)] );  % [x,varnum,modenum]
        V1(:,:,bigdel) = [];
        V1 = permute(V1,[1 3 2]);       % [x,modenum,varnum]
        C = zeros(size(V1));
        for j = 1:size(C,3)  % for each variable
          C(:,:,j) = abs( cd2cp(V1(:,:,j)) );  % cheb coeffs of all modes
        end
        mx = max( max(C,[],1), [], 3 );  % max for each mode over all vars
        [cmin,idx] = min( sum(sum(C,1),3)./mx );  % min 1-norm of each mode
        sigma = lam1(idx);
  else                      % Piecewise
        lam1(bigdel) = [];
        V1 = reshape( V1, [33,numints,m,size(V1,2)] );  % [x,interval,varnum,modenum]
        V1(:,:,:,bigdel) = [];
        V1 = permute(V1,[1 4 2 3]);       % [x,modenum,varnum]
        C = zeros(size(V1));
        for j = 1:size(C,4)  % for each variable
            for l = 1:numints
              C(:,:,l,j) = abs( cd2cp(V1(:,:,l,j)) );  % cheb coeffs of all modes
            end
        end
        mx = max( max( max(C,[],1), [], 3 ) , [], 4);  % max for each mode over all vars
        [cmin,idx] = min( sum(sum(sum(C,1),3),4)./mx );  % min 1-norm of each mode
        sigma = lam1(idx);
  end
end

if strcmpi(sigma,'SM'), sigma = 0; end

% These assignments cause the nested function value() to overwrite them.
V = [];  D = [];  Nout = [];

% Default settings
settings = chebopdefaults;
settings.scale = A.scale;

% Adaptively construct the sum of eigenfunctions.
if numel(breaks) == 2 && ~chebfunpref('splitting')
    chebfun( @(x) value(x), dom, settings);
else
    chebfun( @(x,N,bks) value_sys(x,N,bks), {breaks} , settings);
end
% Now V,D are already defined at the highest value of N used.

if nargout < 2
  varargout = { diag(D) };
elseif numel(breaks) == 2 && ~chebfunpref('splitting')
  V = reshape( V, [N,m,k] );
  Vfun = cell(1,m);
  for j = 1:k
    nrm2 = 0;
    for i = 1:m
      f = chebfun( V(:,i,j), dom, chebopdefaults);
      % This line is needed to simplify/compress the chebfuns.
      f = chebfun( @(x) f(x), dom, chebopdefaults);
      Vfun{i}(:,j) = f;  nrm2 = nrm2 + norm(f)^2;
    end
    % Normalization
    for i = 1:m
      Vfun{i}(:,j) = Vfun{i}(:,j)/sqrt(nrm2);
    end
  end
  if m == 1, Vfun = Vfun{1}; end
  varargout = { Vfun, D };
else
    N = Nout;
    V = mat2cell(V(:),repmat(N,1,m*k),1);

    Vfun = cell(1,m);
    for l = 1:m, Vfun{l} = chebfun; end % initialise
    settings.maxdegree = maxdegree;  settings.maxlength = maxdegree;
    
    for kk = 1:k % Loop over each eigenvector
        nrm2 = 0;
        for l = 1:m % Loop through the equations in the system
            tmp = chebfun; 
            % Build a chebfun from the piecewise parts on each interval
            for j = 1:numel(breaks)-1
                funj = fun( filter(V{1},1e-8), breaks(j:j+1), settings);
                tmp = [tmp ; set(chebfun,'funs',funj,'ends',breaks(j:j+1),...
                    'imps',[funj.vals(1) funj.vals(end)],'trans',0)];
                V(1) = [];
            end
            % Simplify it
            tmp = simplify(tmp,settings.eps);
            Vfun{l}(:,kk) = tmp;
            nrm2 = nrm2 + norm(tmp)^2;
        end
        for l = 1:m % Normalise
            Vfun{l}(:,kk) = Vfun{l}(:,kk)/sqrt(nrm2);
        end
    end
    if m == 1, Vfun = Vfun{1}; end % Return a quasimatrix in this case
    varargout = { Vfun, D };
end

  % Called by the chebfun constructor. Returns values of the sum of the
  % "interesting" eigenfunctions. 
  function v = value(x)
    N = length(x);
    if N > maxdegree+1
      msg = sprintf(...
        'No convergence with %i points. Check sigma, or ask for fewer modes.',...
        maxdegree+1);
      error('LINOP:eigs:NoConverge',msg)
    end
    if N-A.numbc < k
      % Not enough eigenvalues. Return a sawtooth to ensure refinement.
      v = ones(N,1); 
      v(2:2:end) = -1;
    else
      [V,D] = bc_eig(A,B,N,k,sigma,map,breaks);
      v = sum( sum( reshape(V,[N,m,size(V,2)]),2), 3);
      v = filter(v,1e-8);
    end
  end

  % Called by the chebfun constructor. Returns values of the sum of the
  % "interesting" eigenfunctions. 
  function v = value_sys(y,N,bks)
    if nargin == 1, v = y; return, end
    N = N{:};   bks = bks{:};     % We allow only the same discretization
                                    % size and breaks for each system
    maxdo = max(A.difforder(:));  % the maximum derivative order of the system
    
    if m*sum(N) > maxdegree+1
      error('LINOP:mldivide:NoConverge',['Failed to converge with ',int2str(maxdegree+1),' points.'])
    elseif any(N==1)
      error('LINOP:mldivide:OnePoint',...
        'Solution requested at a lone point. Check for a bug in the linop definition.')
    elseif any(N < maxdo+1)
      % Too few points: force refinement
      jj = find(N < maxdo+1);
      csN = [0 ; cumsum(N)];
      v = y;
      for ll = 1:length(jj)
          e = ones(N(jj(ll)),1); e(2:2:end) = -1;
          v{csN(jj(ll))+(1:N(jj(ll)))} = e; 
      end
      return
    elseif sum(N) < k
      % Too few points: force refinement
      v = ones(size(y{1})); v(2:2:end) = -1;  v = {v};
      return
    end    

    [V,D] = bc_eig_sys(A,B,N,k,sigma,map,bks);
    
    v = sum(reshape(V,[sum(N),size(V,2),m]),3);  % Combine equations
    v = sum(v,2);                        % Combine nodes

    % Filter
    csN = cumsum([0 N]);
    for jj = 1:numel(N)
      ii = csN(jj) + (1:N(jj));
      v(ii) = filter(v(ii),1e-8);
    end
    v = {v};  

    % Store these to be used by the wrapper function
    Nout = N;

  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [V,D] = bc_eig_old(A,B,N,k,sigma,map,breaks)
breaks = union(breaks,A.fundomain.endsandbreaks);
if (numel(N) == 1 && numel(breaks) > 2)
    N = repmat(N,1,numel(breaks)-1);
end
% Computes the (discrete) e-vals and e-vecs. 
m = A.blocksize(1);
% Instantiate A, with row replacements.
L = feval(A,N,map,breaks);
[Abdy,c,rowrep] = bdyreplace_old(A,N,map,breaks);
L(rowrep,:) = Abdy;
elim = false(N*m,1);
elim(rowrep) = true;

if isempty(B)
  % Use algebra with the BCs to remove degrees of freedom.
  R = -L(elim,elim)\L(elim,~elim);  % maps interior to removed values
  L = L(~elim,~elim) + L(~elim,elim)*R;
  [W,D] = eig(full(L));
  idx = nearest(diag(D),W,sigma,min(k,N),N);
  V = zeros(N*m,length(idx));
  V(~elim,:) = W(:,idx);
  V(elim,:) = R*V(~elim,:);
else
  % Use generalized problem to impose the BCs.
  M = feval(B,N,map);
  %FIXME: Kludge when B is given BCs. We have to assume that these are 
  % given in the same order as they are in A. I can't see any way to check 
  % up on this. 
  Bbdy = bdyreplace_old(B,N);
  nla = length(A.lbc);  nra = length(A.rbc);
  nlb = length(B.lbc);  nrb = length(B.rbc);
  Brows = rowrep( [1:nlb, nla+(1:nrb)] );
  M(Brows,:) = Bbdy;
  % For rows of B that were not replaced, default to zero rows.
  elim(Brows) = false;
  M(elim,:) = 0;
  [W,D] = eig(full(L),full(M));
  
  % We created some infinite eigenvalues. Peel them off. 
  [lam,idx] = sort( abs(diag(D)),'descend' );
  idx = idx(1:sum(elim));
  D(:,idx) = [];  D(idx,:) = [];  W(:,idx) = [];
  idx = nearest(diag(D),W,sigma,min(k,N),N);
  V = W(:,idx);
end
D = D(idx,idx);

end


function [V,D] = bc_eig(A,B,N,k,sigma,map,breaks)

    if ~isempty(B) % Generalised
% [V,D] = bc_eig_old(A,B,N,k,sigma,map,breaks);
% return

        % Force difforder to be the same, so that projection P is the same.
        do = max(A.difforder, B.difforder);
        A.difforder = do; B.difforder = do;
        
        % Evaluate A and Bat size N
        Amat = feval(A,N,'bc',map,breaks);
        Bmat = feval(B,N,'bc',map,breaks);

        % Square up matrices if # of boundary conditions is not the same.
        sizediff = size(Amat,1)-size(Bmat,1);
        Amat = [Amat ; zeros(-sizediff,size(Amat,2))];
        Bmat = [Bmat ; zeros(sizediff,size(Bmat,2))];

        % Compute the generalised eigenvalue problem.       
        [V,D] = eig(full(Amat),full(Bmat));
        
        % Find the droids we're looking for.
        idx = nearest(diag(D),V,sigma,min(k,N),N);
        V = V(:,idx);
        D = D(idx,idx);

    else % not generalised

    % Evaluate the Matrix with boundary conditions attached
    [Amat,ignored,c,ignored,P] = feval(A,N,'bc',map,breaks);
        % Compute the (discrete) e-vals and e-vecs generalised e-val problem.

    m = A.blocksize(1);
    if m == 1
        Pmat = [P ; zeros(numel(c),N)];
    else
        Pmat = zeros(sum(N)*m);
        i1 = 0; i2 = 0;
        for j = 1:A.blocksize(1)
            ii1 = i1+(1:size(P{j},1));
            ii2 = i2+(1:size(P{j},2));
            Pmat(ii1,ii2) = P{j};
            i1 = ii1(end); i2 = ii2(end);
        end   
    end

        % Compute generalised e-val problem.
        [V,D] = eig(full(Amat),full(Pmat));

        % Find the droids we're looking for.
        idx = nearest(diag(D),V,sigma,min(k,N),N);
        V = V(:,idx);
        D = D(idx,idx);
        
    end
            
%     if size(V,2) < k
%         % Matrix wasn't big enough
%         v = ones(size(V,1),1); v(2:2:end) = -1;
%         V = [V repmat(v,1,k-size(V,2))];
%         D = NaN(size(V,1),1);
%     end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [V,D] = bc_eig_sys(A,B,N,k,sigma,map,bks)
    % y is a cell array with the points for each function.
    % N{j}(k) contains the # of pts for equation j on interval k.
    % bks{j}(k:k+1) is the ends of the interval j for equation k.
    
    m = A.blocksize(1);
    numints = numel(bks)-1;
    if numel(N) == 1, N = repmat(N,1,numints); end

    if ~isempty(B) % Generalised
%         [V,D] = bc_eig_old(A,B,N,k,sigma,map,breaks);
%         return

        % Force difforder to be the same, so that projection P is the same.
        do = max(A.difforder, B.difforder);
        A.difforder = do; B.difforder = do;
        
        % Evaluate A and Bat size N
        Amat = feval(A,N,'bc',map,bks);
        Bmat = feval(B,N,'bc',map,bks);

        % Square up matrices if # of boundary conditions is not the same.
        sizediff = size(Amat,1)-size(Bmat,1);
        Amat = [Amat ; zeros(-sizediff,size(Amat,2))];
        Bmat = [Bmat ; zeros(sizediff,size(Bmat,2))];

        % Compute the generalised eigenvalue problem.       
        [V,D] = eig(full(Amat),full(Bmat));
        
        % Find the droids we're looking for.
        idx = nearest(diag(D),V,sigma,min(k,N),N);
        V = V(:,idx);
        D = D(idx,idx);

    else % Not generalised

    % Evaluate the Matrix with boundary conditions attached
        [Amat,ignored,c,ignored,P] = feval(A,N,'bc',map,bks);
    
        if m == 1
            Pmat = [P ; zeros(numel(c),sum(N)*m)];
        else
            Pmat = zeros(sum(N)*m);
            i1 = 0; i2 = 0;
            for j = 1:A.blocksize(1)
                ii1 = i1+(1:size(P{j},1));
                ii2 = i2+(1:size(P{j},2));
                Pmat(ii1,ii2) = P{j};
                i1 = ii1(end); i2 = ii2(end);
            end   
        end

        % Compute generalised e-val problem.
        [V,D] = eig(full(Amat),full(Pmat));

        % Find the droids we're looking for.
        idx = nearest(diag(D),V,sigma,min(k,N),N);
        V = V(:,idx);
        D = D(idx,idx);
        
    end

    if size(V,2) < k
        % Matrix wasn't big enough
        v = ones(size(V,1),1); v(2:2:end) = -1;
        V = [V repmat(v,1,k-size(V,2))];
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns index vector that sorts eigenvalues by the given criterion.
function idx = nearest(lam,V,sigma,k,N)

if nargin < 5, N = NaN; end

if isnumeric(sigma)
  if isinf(sigma) 
    [junk,idx] = sort(abs(lam),'descend');
  else
    [junk,idx] = sort(abs(lam-sigma));
  end
else
  switch upper(sigma)
    case 'LR'
      [junk,idx] = sort(real(lam),'descend');
    case 'SR'
      [junk,idx] = sort(real(lam));
    case 'LI'
      [junk,idx] = sort(imag(lam),'descend');
    case 'SI'
      [junk,idx] = sort(imag(lam));
    case 'LM'
      [junk,idx] = sort(abs(lam),'descend');
    % case 'SM' already converted to sigma=0
    otherwise
      error('CHEBFUN:linop:eigs:sigma', 'Unidentified input ''sigma''.');
  end
end

% Delete infinite values. These can arise from rank deficiencies in the 
% RHS matrix of the generalized eigenproblem.
idx( ~isfinite(lam(idx)) ) = [];

% Propose to keep these modes.
queue = 1:min(k,length(idx));
keeper = false(size(idx));
keeper(queue) = true;
    
% Screen out spurious modes. These are dominated by high frequency for all
% values of N. (Known to arise for some formulations in generalized
% eigenproblems, specifically Orr-Sommerfeld.)
while ~isempty(queue)
  j = queue(1);

  if numel(N) == 1
      vc = chebpoly( chebfun(V(:,idx(j))), 1 );
  else
      vc = zeros(1,max(N));
      csN = cumsum([0 N]);
      for jj = 1:numel(N)
          % We can save time (and FFTs) by combining intervals which
          % have the same discretisation length (say, N(i) = N(j)). TODO.
          ii = csN(jj) + (1:N(jj));
          tmp = chebpoly( chebfun(V(ii,idx(j))), 1 );
          vc(1:N(jj)) = vc(1:N(jj))+tmp(end:-1:1);
      end
      vc = vc(end:-1:1);
  end

  tenPercent = ceil(N/10);
  ii1 = 1:tenPercent; % First 10%
  ii2 = 1:(N-tenPercent); % First 90%
  if norm( vc(ii1) ) > 0.5*norm(vc(ii2))
    keeper(j) = false;
    if queue(end) < length(idx)
      m = queue(end)+1;
      keeper(m) = true;  queue = [queue(:); m];
    end
  end
  queue(1) = [];
  
end

% Return the keepers.
idx = idx( keeper );

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = cd2cp(y)
%CD2CP  Chebyshev discretization to Chebyshev polynomials (by FFT).
%   P = CD2CP(Y) converts a vector of values at the Chebyshev extreme
%   points to the coefficients (ascending order) of the interpolating
%   Chebyshev expansion.  If Y is a matrix, the conversion is done
%   columnwise.

p = zeros(size(y));
if any(size(y)==1), y = y(:); end
N = size(y,1)-1;

yhat = fft([y(N+1:-1:1,:);y(2:N,:)])/(2*N);

p(2:N,:) = 2*yhat(2:N,:);
p([1,N+1],:) = yhat([1,N+1],:);

if isreal(y),  p = real(p);  end

end