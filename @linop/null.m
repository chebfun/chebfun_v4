function Vfun = null(A,varargin)
%NULL   Null space.
% Z = NULL(A) is a chebfun quasimatrix orthonormal basis for the null space
% of the linop A. That is, A*Z has negligible elements, size(Z,2) is the
% nullity of A, and Z'*Z = I. A may contain linar boundary conditions, but
% they will be treated as homogenous.
%
% Example 1:
%  [d,x] = domain(0,pi);
%  A = diff(d);
%  V = null(A);
%  norm(A*V)
%
% Example 2:
%  [d x] = domain(-1,1);
%  L = 0.2*diff(d,3) - diag(sin(3*x))*diff(d);
%  L.rbc = 1;
%  V = null(L)
%
% See also linop/svds, linop/eigs.

% Copyright 2011 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if nargin > 1
    error('CHEBFUN:linop:null:r',...
        '"rational" null space basis is not yet supported.');
end

dom = domain(A);
breaks = dom.endsandbreaks;
nullity = [];

m = A.blocksize(2);             % Number of variabes in system
V = [];  % Initialise V so that the nested function overwrites it.

% Grab the default settings.
maxdegree = cheboppref('maxdegree');
settings = chebopdefaults;
settings.minsamples = 33;
tol = 100*settings.eps;

% Call the constructor
ignored = chebfun( @(x,N,bks) value(x,N,bks), {breaks}, settings);

N = Nout;
V = mat2cell(V(:),repmat(N,1,m*nullity),1);

Vfun = cell(1,m);
for l = 1:m, Vfun{l} = chebfun; end % initialise
settings.maxdegree = maxdegree;  settings.maxlength = maxdegree;

for kk = 1:nullity % Loop over each eigenvector
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

% Orthogonalise
Vfun = qr(Vfun);

 function v = value(y,N,bks)
    % y is a cell array with the points for each function.
    % N is the number of points on each subinterval.
    % bks contains the ends of the subintervals.
    N = N{:};   bks = bks{:};         % We allow only the same discretization
    csN = [0 cumsum(N)]; sN = sum(N); %  size and breaks for each system.
    maxdo = max(A.difforder(:));      % Maximum derivative order of the system.

    % Error checking
    if sum(N) > maxdegree+1
      error('LINOP:mldivide:NoConverge',...
          ['Failed to converge with ',int2str(maxdegree+1),' points.'])
    elseif any(N==1)
      error('LINOP:mldivide:OnePoint',...
        'Solution requested at a lone point. Check for a bug in the linop definition.')
    elseif any(N < maxdo+1)
      % Too few points: force refinement.
      jj = find(N < maxdo+1);
      v = y;
      for kk = 1:length(jj)
          e = ones(N(jj(kk)),1); e(2:2:end) = -1;
          v{csN(jj(kk))+(1:N(jj(kk)))} = e; 
      end
      return
    end 
        
    % Get collocation matrix.
    [ignored,B,ignored,ignored,ignored,Amat] = feval(A,N,'bc',[],bks);
        
    if diff(size(Amat)),
        error('chebfun:linop:null', ...
            'Nonsquare collocation currently not supported.')
    end

    [U,S,v] = svd(Amat);                    % Built-in SVD
    S = diag(S);
    tol = 1e-14;
    nullity = length(find(S/S(1) < tol));   % Numerical nullity
    v = v(:,end+1-nullity:end);             % Numerical nullvectors
    v = reshape(v,[sN,nullity]);            % one variable per column
    
    % Enforce additional boundary conditions and store for output
    V = v*null(B*v);

    % Need to return a single function to test happiness. If you just sum
    % functions, you get weird results if v(:,1)=-v(:,2), as can happen in
    % very basic problems. We just use an arbitrary linear combination (but
    % the same one each time!). 
    coef = [1, 2 + sin(1:nullity-1)];  % For a linear combination of variables
    v = v*coef.';
    % Filter
    for jj = 1:numel(N)
        ii = csN(jj) + (1:N(jj));
        v(ii) = filter(v(ii),1e-8);
    end
    v = {v};                                % Output as cell array.
    
    % Some outputs
    nullity = size(V,2);
    Nout = N;

    end
end
