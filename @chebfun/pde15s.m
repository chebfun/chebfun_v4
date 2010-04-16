function varargout = pde15s( pdefun, tt, u0, bc, varargin)
%PDE15S  Solve PDEs using the chebfun system
% UU = PDE15s(PDEFUN, TT, U0, BC) where PDEFUN is a handle to a function with 
% arguments u, t, x, and D, TT is a vector, U0 is a chebfun, and BC is a 
% chebop boundary condition structure will solve the PDE dUdt = PDEFUN(UU,t,x)
% with the initial condition U0 and boundary conditions BC over the time
% interval TT. D in PDEFUN represents the differential operator of U, and
% D(u,K) will represent the Kth derivative of u.
%
% For equations of one variable, UU is output as a quasimatrix, where UU(:,k)
% is the solution at TT(k). For systems, the solution is returned as a
% cell array of quasimatrices.
%
% Example 1: Nonuniform advection
%   [d,x] = domain(-1,1);
%   u = exp(3*sin(pi*x));
%   f = @(u,t,x,D) -(1+0.6*sin(pi*x)).*D(u);
%   uu = pde15s(f,0:.05:3,u,'periodic');
%   surf(u,0:.05:3)
%
% Example 2: Kuramoto-Sivashinsky
%   [d,x] = domain(-1,1);
%   I = eye(d); D = diff(d);
%   u = 1 + 0.5*exp(-40*x.^2);
%   bc.left = struct('op',{I,D},'val',{1,2});
%   bc.right = struct('op',{I,D},'val',{1,2});
%   f = @(u,D) u.*D(u)-D(u,2)-0.006*D(u,4);
%   uu = pde15s(f,0:.01:.5,u,bc);
%   surf(u,0:.01:.5)
% 
% Example 3: Chemical reaction (system)
%    [d,x] = domain(-1,1);  
%    u = [ 1-erf(10*(x+0.7)) , 1 + erf(10*(x-0.7)) , chebfun(0,d) ];
%    f = @(u,v,w,diff)  [ 0.1*diff(u,2) - 100*u.*v , ...
%                      0.2*diff(v,2) - 100*u.*v , ...
%                     .001*diff(w,2) + 2*100*u.*v ];
%    bc = 'neumann';     
%    uu = pde15s(f,0:.1:3,u,bc);
%    mesh(uu{3})
%
% UU = PDE15s(PDEFUN, TT, U0, BC, OPTS) will use nondefault options as
% defined by the structure returned from OPTS = PDESET.
%
% UU = PDE15s(PDEFUN, TT, U0, BC, OPTS, N) will not adapt the grid size
% in space. Alternatively OPTS.N can be set to the desired size.
%
% [TT UU] = PDE15s(...) returns also the time chunks TT.
%
% There is some support for nonlinear boundary conditions, such as
%    BC.LEFT = @(u,t,x,D) D(u) + u - (1+2*sin(10*t));
%    BC.RIGHT = struct( 'op', 'dirichlet', 'val', @(t) .1*sin(t));
%
% See also chebfun/examples/pde15s_demos, pdeset, ode15s
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

global ORDER QUASIN GLOBX
ORDER = 0; % Initialise to zero

if nargin < 4 
    error('CHEBFUN:pde15s:argin','pde15s requires a minimum of 4 inputs');
end

% Default options
tol = 1e-6;             % 'eps' in chebfun terminology
doplot = 1;             % plot after every time chunk?
dohold = 0;             % hold plot?
plotopts = '-';         % Plot Style

% Parse the inputs
if numel(varargin) == 2
    opt = varargin{1};     opt.N = varargin{2};
elseif numel(varargin) == 1
    if isstruct(varargin{1})
        opt = varargin{1};
    else
        opt = pdeset;      opt.N = varargin{1};
    end
else
    opt = pdeset;
end
optN = opt.N;
if isempty(optN), optN = NaN; end
    
% PDE solver options
if ~isempty(opt.Eps), tol = opt.Eps; end
if ~isempty(opt.Plot), doplot = strcmpi(opt.Plot,'on'); end
if ~isempty(opt.HoldPlot), dohold = strcmpi(opt.HoldPlot,'on'); end
if ~isempty(opt.PlotStyle), plotopts = opt.PlotStyle; end
YLim = opt.YLim;
if isfield(opt,'guihandles') 
    axes(opt.guihandles{1})
    guiflag = true;
else
    guiflag = false; 
end

% ODE tolerances
% (AbsTol and RelTol must be <= Tol/10)
atol = odeget(opt,'AbsTol',tol/10);
rtol = odeget(opt,'RelTol',tol/10);
if isnan(optN)
    atol = min(atol, tol/10);
    rtol = min(rtol, tol/10);
end
opt.AbsTol = atol; opt.RelTol = rtol;

% Get the domain
d = domain(u0);

% Determine the size of the system
syssize = min(size(u0));

% % If the differential operator is passed, redefine the anonymous function
% tmp = NaN(1,syssize);
% if nargin(pdefun) == 2
%     pdefun = @(u,t,x) pdefun(u,@Diff);
%     % get the ORDER (a global variable) by evaluating the RHS with NaNs
%     pdefun(tmp);
% elseif nargin(pdefun) == 4
%     pdefun = @(u,t,x) pdefun(u,t,x,@Diff);
%     pdefun(tmp,NaN,NaN); % (as above)
% end

% Determining the behaviour of the inputs to pdefun, i.e. is it of
% quasimatrix-type, or pdefun(u,v,w,t,x,@diff) etc. (QUASIN TRUE/FALSE).
tmp = NaN(1,syssize); QUASIN = true;
% Determine if it's a quasimatrix
if nargin(pdefun) == 4 && syssize ~= 1 
    % This is the tricky case: we could have
    %   op(u,t,x,@Diff) or op(u,v,w,@Diff)
    try
        tmp2 = repmat({tmp},1,nargin(pdefun)-2);
        pdefun(tmp,tmp2{:},@Diff);
    end
    try
        tmp2 = repmat({NaN},1,nargin(pdefun)-2);
        pdefun(tmp,tmp2{:},@Diff);
    end
elseif syssize == 1 || nargin(pdefun) < 3
    QUASIN = true;
else
    QUASIN = false;
end

% Convert pdefun to accept quasimatrix inputs, and determine syssize
if nargin(pdefun) == 2 || (~QUASIN && nargin(pdefun) == syssize + 1)
    if QUASIN pdefun = @(u,t,x) pdefun(u,@Diff);
    else      pdefun = @(u,t,x) conv2cell(pdefun,u,@Diff);
    end
    pdefun(tmp); % Get the ORDER (global) by evaluating the RHS with NaNs
elseif nargin(pdefun) == syssize + 3 || nargin(pdefun) == 4
    if QUASIN
        pdefun = @(u,t,x) pdefun(u,t,x,@Diff);
    else
        pdefun = @(u,t,x) conv2cell(pdefun,u,t,x,@Diff);
    end
    pdefun(tmp,NaN,NaN); % (as above)
end

    function newfun = conv2cell(oldfun,u,varargin)
    % This function allows the use of different variables in the anonymous 
    % function, rather than using the clunky quasi-matrix notation.
        tmpcell = cell(1,syssize);
        for qk = 1:syssize
            tmpcell{qk} = u(:,qk);
        end
        newfun = oldfun(tmpcell{:},varargin{:});
%         % This looks slicker, but is slower.
%         u = num2cell(u,1);
%         newfun = oldfun(u{:},varargin{:});
    end

% Some error checking on the bcs
if ischar(bc) && (strcmpi(bc,'neumann') || strcmpi(bc,'dirichlet'))
    if ORDER > 2
        error('CHEBFUN:pde15s:bcs',['Cannot assign "', bc, '" boundary conditions to a ', ...
        'RHS with differential order ', int2str(ORDER),'.']);
    end
    bc = struct( 'left', bc, 'right', bc);
elseif iscell(bc) && numel(bc) == 2
    bc = struct( 'left', bc{1}, 'right', bc{2});
end

Z = zeros(d);  % This is used often.
% Shorthand bcs - all neumann or all dirichlet
if isfield(bc,'left') && ischar(bc.left)
    if strcmpi(bc.left,'dirichlet'),    A = eye(d);
    elseif strcmpi(bc.left,'neumann'),  A = diff(d);
    end
    op = cell(1,syssize);
    for k = 1:syssize,   op{k} = [repmat(Z,1,k-1) A repmat(Z,1,syssize-k)];  end
    bc.left = struct('op',op,'val',repmat({0},1,syssize));
end
if isfield(bc,'right') && ischar(bc.right)
    if strcmpi(bc.right,'dirichlet'),    A = eye(d);
    elseif strcmpi(bc.right,'neumann'),  A = diff(d);
    end
    op = cell(1,syssize);
    for k = 1:syssize,   op{k} = [repmat(Z,1,k-1) A repmat(Z,1,syssize-k)];  end
    bc.right = struct('op',op,'val',repmat({0},1,syssize));
end

% Sort out left boundary conditions
nllbc = []; nlbcs = {}; GLOBX = 1; funflagl = false; rhs = [];
% 1) Deal with the case where bc is a function handle vector
if isfield(bc,'left') && numel(bc.left) == 1 && isa(bc.left,'function_handle')
	op = bc.left;
    if nargin(op) == 2 || (~QUASIN && nargin(op) == syssize + 1)
        if QUASIN, op = @(u,t,x) op(u,@Diff);
        else       op = @(u,t,x) conv2cell(op,u,@Diff);
        end
    else
        if QUASIN  op = @(u,t,x) op(u,t,x,@Diff);
        else       op = @(u,t,x) conv2cell(op,u,t,x,@Diff);
        end
    end
    tmp2 = ones(size(tmp));  sop = size(op(tmp2,0,1));   
    nllbc = 1:max(sop);    
    bc.left = struct( 'op', [], 'val', []); 
    
    % Dummy entries
    if syssize == 1
        for k = nllbc 
            bc.left(k).op = repmat(eye(d),1,syssize);
            bc.left(k).val = 0;
        end
    else
        for k = nllbc 
            bc.left(k).op = [repmat(Z,1,k-1) eye(d) repmat(Z,1,syssize-k)];
            bc.left(k).val = 0;
        end  
    end
    rhs = num2cell(zeros(1,max(sop)));
    nlbcsl = op;
    funflagl = true;
end


% 2) Deal with other forms of input
if ~funflagl && isfield(bc,'left') && numel(bc.left) > 0
    if isa(bc.left,'function_handle') || isa(bc.left,'linop') || iscell(bc.left)
        bc.left = struct( 'op', bc.left);
    elseif isnumeric(bc.left)
        bc.left = struct( 'op', eye(d), 'val', bc.left); 
    end
    % Extract nonlinear conditions
    for k = 1:numel(bc.left)
        opk = bc.left(k).op; rhs{k} = 0;
        if isnumeric(opk) && syssize == 1
            bc.left(k).op = repmat(eye(d),1,syssize);
            bc.left(k).val = opk;
        end       
        if isa(opk,'function_handle')
            nllbc = [nllbc k];             % Store positions
            if nargin(opk) == 2, nlbcs = [nlbcs {@(u,t,x) opk(u,@Diff)} ];
            else                 nlbcs = [nlbcs {@(u,t,x) opk(u,t,x,@Diff)}]; end
%             bc.left(k).op = repmat(eye(d),1,syssize);
            bc.left(k).op = [repmat(Z,1,k-1) eye(d) repmat(Z,1,syssize-k)];
        end
        if isfield(bc.left(k),'val') && ~isempty(bc.left(k).val)
                rhs{k} = bc.left(k).val;
        end
        bc.left(k).val = 0;  % set to homogeneous (to remove function handles)
    end     
elseif ~funflagl && isfield(bc,'right') 
    bc.left = [];
end

% Sort out right boundary conditions
nlrbc = []; numlbc = numel(rhs); funflagr = false;
% 1) Deal with the case where bc is a function handle vector
if isfield(bc,'right') && numel(bc.right) == 1 && isa(bc.right,'function_handle')
	op = bc.right;
    if nargin(op) == 2 || (~QUASIN && nargin(op) == syssize + 1)
        if QUASIN, op = @(u,t,x) op(u,@Diff);
        else       op = @(u,t,x) conv2cell(op,u,@Diff);
        end
    else
        if QUASIN  op = @(u,t,x) op(u,t,x,@Diff);
        else       op = @(u,t,x) conv2cell(op,u,t,x,@Diff);
        end
    end
    tmp2 = ones(size(tmp));  evalop = op(tmp2,0,1);   s = size(evalop);    
    nlrbc = 1:max(s);
    bc.right = struct( 'op', [], 'val', []); 
    % Dummy entries
    if syssize == 1
        for k = nllbc 
            bc.right(k).op = repmat(eye(d),1,syssize);
            bc.right(k).val = 0;
        end
    else
        for k = nllbc 
            bc.right(k).op = [repmat(Z,1,k-1) eye(d) repmat(Z,1,syssize-k)];
            bc.right(k).val = 0;
        end  
    end
    rhs = [rhs num2cell(zeros(1,max(sop)))];
    nlbcsr = op;
    funflagr = true;
end
% 2) Deal with other forms of input
if ~funflagr && isfield(bc,'right') && numel(bc.right) > 0
    if isa(bc.right,'function_handle') || isa(bc.right,'linop') || isa(bc.right,'cell')
        bc.right = struct( 'op', bc.right, 'val', 0);
    elseif isnumeric(bc.right)
        bc.right = struct( 'op', eye(d), 'val', bc.right);         
    end
    for k = 1:numel(bc.right)
        opk = bc.right(k).op; rhs{numlbc+k} = 0;
        if isnumeric(opk) && syssize == 1
            bc.right(k).op = eye(d);
            bc.right(k).val = opk;
        end
        if isa(opk,'function_handle')
            nlrbc = [nlrbc k];
            if nargin(opk) == 2,  nlbcs = [nlbcs {@(u,t,x) opk(u,@Diff)} ];
            else                  nlbcs = [nlbcs {@(u,t,x) opk(u,t,x,@Diff)}]; end
%             bc.right(k).op = repmat(eye(d),1,syssize);
            bc.right(k).op = [repmat(Z,1,k-1) eye(d) repmat(Z,1,syssize-k)];
        end
        if isfield(bc.right(k),'val') && ~isempty(bc.right(k).val)
                rhs{numlbc+k} = bc.right(k).val;
        end
        bc.right(k).val = 0;
    end          
elseif ~funflagr && isfield(bc,'left') 
    bc.right = [];
end

% Support for user-defined mass matrices - experimental!
if ~isempty(opt.Mass)
    if isa(opt.Mass,'chebop')
        usermass = true;
        userM = opt.Mass;
    else
        error('CHEBFUN:pde15s:Mass','Mass matrix must be a chebop');
    end
else
    usermass = false; 
end

% This is needed inside the nested function onestep()
diffop = diff(d,ORDER);
if syssize > 1
    diffop = repmat(diffop,syssize,syssize);
end

% simplify initial condition  to tolerance or fixed size in optN
if isnan(optN)
    u0 = simplify(u0,tol);
end

% The vertical scale of the intial condition
vscl = u0.scl;

% Plotting setup
if doplot
    if ~guiflag
        cla, shg
    end
    set(gcf,'doublebuf','on')
    plot(u0,plotopts)
    if dohold, ish = ishold; hold on, end
    if ~isempty(YLim), ylim(YLim);    end
    drawnow
end

% initial condition
ucur = u0;
% storage
if syssize == 1
    uu = repmat(chebfun(0,d),1,length(tt));
    uu(:,1) = ucur;
else
    % for systems, each functions is stored as a quasimatrix in a cell array
    uu = cell(1,syssize);
    for k = 1:syssize
        tmp = repmat(chebfun(0,d),1,length(tt));
        tmp(:,1) = ucur(:,k);
        uu{k} = tmp;
    end
end

% initialise variables for onestep()
B = []; q = []; rows = []; M = []; n = [];

% Begin time chunks
for nt = 1:length(tt)-1
    
    % size of current length
    curlen = 0;
    for k = 1:syssize, curlen = max(curlen,length(ucur(:,k))); end
    
    % solve one chunk
    if isnan(optN)
        chebfun( @(x) vscl+onestep(x), d, 'eps', tol, 'minsamples',curlen, ...
            'resampling','on','splitting','off','sampletest','off','blowup','off');
    else
        % non-adaptive in space
        onestep(chebpts(optN,d));
    end
    
    % get chebfun of solution from this time chunk
    for k = 1:syssize, ucur(:,k) = chebfun(unew(:,k),d); end
    
    if isnan(optN) 
        ucur = simplify(ucur,tol);
    end

    % store in uu
    if syssize == 1,  
        uu(:,nt+1) = ucur;
    else
        for k = 1:syssize
            tmp = uu{k};
            tmp(:,nt+1) = ucur(:,k);
            uu{k} = tmp;
        end
    end
    
    % plotting
    if doplot
        plot(ucur,plotopts);
        if ~isempty(YLim), ylim(YLim); end
        title(sprintf('t = %.3f,  len = %i',tt(nt+1),curlen)), drawnow
    end
    
    % Interupt comutation if stop button is pressed in the GUI.
    if isfield(opt,'guihandles') && strcmp(get(opt.guihandles{6},'String'),'Stop') && strcmpi(get(opt.guihandles{6},'Enable'),'Off')
        if syssize == 1,  
            uu = uu(:,1:nt+1);
            tt = tt(1:nt+1);
        end
        break
    end
end

if doplot && dohold && ~ish, hold off, end

switch nargout
    case 0
    case 1        
        varargout{1} = uu;
    case 2
        varargout{1} = tt;
        varargout{2} = uu;
    otherwise
        error('CHEBFUN:pde15s:output','pde15s may only have a maximum of two outputs');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    ONESTEP   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constructs the result of one time chunk at fixed discretization
    function U = onestep(x)
%         global GLOBX

        if length(x) == 2, U = [0;0]; return, end      
        
        % Evaluate the chebfun at discrete points
        U0 = feval(ucur,x);

        % This depends only on the size of n. If this is the same, reuse
        if isempty(n) || n ~= length(x)
            n = length(x);  % the new discretisation length
            
            GLOBX = x;      % set the global variable x
            
            % See what the boundary replacement actions will be.

            [ignored,B,q,rows] = feval( diffop & bc, n, 'bc' );
            % Mass matrix is I except for algebraic rows for the BCs.
            M = speye(syssize*n);    M(rows,:) = 0;
        
            % Multiply by user-defined mass matrix
            if usermass, M = feval(userM,n)*M; end
            
        end
        
        % ODE options (mass matrix)
        opt2 = odeset(opt,'Mass',M,'MassSingular','yes','InitialSlope',odefun(tt(nt),U0));

        % Solve ODE over time chunk with ode15s
        [ignored,U] = ode15s(@odefun,tt(nt:nt+1),U0,opt2);
        
        % Reshape solution
        U = reshape(U(end,:).',n,syssize);
        
        % The solution we'll take out and store
        unew = U;
        
        % Collapse systems to single chebfun for constructor (is addition right?)
        U = sum(U,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    ODEFUN   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % This is what ode15s calls.
        function F = odefun(t,U)
            
            % Reshape to n by syssize
            U = reshape(U,n,syssize);
            
            % Evaluate the PDEFUN
            F = pdefun(U,t,x);
            
            % Get the algebraic right-hand sides (may be time-dependent)
            for l = 1:numel(rhs)
                if isa(rhs{l},'function_handle')
                    q(l,1) = feval(rhs{l},t);
                else
                    q(l,1) = rhs{l};
                end
            end
            
            % replacements for the BC algebraic conditions           
            F(rows) = B*U(:)-q; 
            B*U(:)-q;
            
            % replacements for the nonlinear BC conditions
            indx = 1:length(nllbc);
            if funflagl    
                tmp = feval(nlbcsl,U,t,x);
                if ~(size(tmp,1) == n)
                    tmp = reshape(tmp,n,numel(tmp)/n);
                end
                F(rows(indx)) = tmp(1,:);
            else
                j = 0;
                for kk = 1:length(nllbc)
                    j = j + 1;
                    tmp = feval(nlbcs{j},U,t,x);
                    F(rows(kk)) = tmp(1)-q(kk);
                end
            end
            indx = numel(rhs)+1-nlrbc;
            if funflagr
                tmp = feval(nlbcsr,U,t,x);
                if ~(size(tmp,1) == n)
                    tmp = reshape(tmp,n,numel(tmp)/n);
                end
                F(rows(indx)) = fliplr(tmp(end,:));                
            else
                for kk = numel(rhs)+1-nlrbc
                    j = j + 1;
                    tmp = feval(nlbcs{j},U,t,x);
                    F(rows(kk)) = tmp(end)-q(kk);
                end
            end

            % Reshape to single column
            F = F(:);
            
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   DIFF   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% The differential operators
function up = Diff(u,k,lr)
    % Computes the k-th derivative of u using Chebyshev differentiation
    % matrices defined by barymat. The matrices are stored for speed.
    
    global GLOBX ORDER QUASIN
    persistent storage
    if isempty(storage), storage = struct([]); end

    % Assume first-order derivative
    if nargin == 1, k = 1; end

    % For finding the order of the RHS
    if any(isnan(u)) 
        if isempty(ORDER), ORDER = k;
        else ORDER = max(ORDER,k); end
        if size(u,2) > 1, QUASIN = false; end
        up = [];
        return
    end
    
    N = length(u);
    
    % Retrieve or compute matrix.
    if N > 5 && length(storage) >= N && numel(storage(N).D) >= k && ~isempty(storage(N).D{k})
        % Matrix is already in storage
    else
        x = GLOBX;
        % Which differentiation matrices do we need?
        switch ORDER
            case 1
                storage(N).D{1} = barymat(x);
            case 2
                [storage(N).D{1} storage(N).D{2}] = barymat(x);
            case 3
                [storage(N).D{1} storage(N).D{2} storage(N).D{3}] = barymat(x);
            case 4
                [storage(N).D{1} storage(N).D{2} storage(N).D{3} storage(N).D{4}] = barymat(x);
            otherwise
                error('CHEBFUN:Diff:order','Diff can only produce matrices upto 4th order');
        end

    end

    % Find the derivative by muliplying by the kth-order differentiation matrix
    if nargin < 3
        up = storage(N).D{k}*u;
    else
    % We only need the end value (for boundary conditions).
        if strcmp(lr,'l')
            up = storage(N).D{k}(1,:)*u;
        else
            up = storage(N).D{k}(N,:)*u;
        end
    end
end       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    BARMAT   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D1 D2 D3 D4] = barymat(x,w)
% BARYMAT  Barycentric differentiation matrix with arbitrary weights/nodes.
%  D = BARYMAT(X,W) creates the first-order differentiation matrix with
%       nodes X and weights W.
%  D = BARYMAT(X) assumes Chebyshev weights.
%  [D1 D2 D3 D4] = BARYMAT(X,W) returns differentiation matrices of upto
%  order 4.
%  All inputs should be column vectors.
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.
%
%  Taken from T. W. Tee's Thesis.

N = length(x)-1;
if N == 0
    N = x;
    x = chebpts(N);
end

if N == 1;
    D1 = 1; D2 = 1; D3 = 1; D4 = 1; 
    return
end

if nargin < 2           % Default to Chebyshev weights
    w = [.5 ; ones(N,1)]; 
    w(2:2:end) = -1;
    w(end) = .5*w(end);
end

if nargout > 4
    error('chebfun:barymat:nargout',['barymat only supports differentiation ', ...
        'matrices upto and including order 4']);
end

ii = (1:N+2:(N+1)^2)';
Dw = repmat(w',N+1,1) ./ repmat(w,1,N+1) - eye(N+1);
Dx = repmat(x ,1,N+1) - repmat(x',N+1,1) + eye(N+1);

D1 = Dw ./ Dx;
D1(ii) = 0; D1(ii) = - sum(D1,2);
if (nargout == 1), return; end
D2 = 2*D1 .* (repmat(D1(ii),1,N+1) - 1./Dx);
D2(ii) = 0; D2(ii) = - sum(D2,2);
if (nargout == 2), return; end
D3 = 3./Dx .* (Dw.*repmat(D2(ii),1,N+1) - D2);
D3(ii) = 0; D3(ii) = - sum(D3,2);
if (nargout == 3), return; end
D4 = 4./Dx .* (Dw.*repmat(D3(ii),1,N+1) - D3);
D4(ii) = 0; D4(ii) = - sum(D4,2);
end

function y = extract_opk(opk,k,s,u,varargin)

y = opk(u,varargin{:});
if s(1) == 1
    y = y(:,k);
else
    y = reshape(y,numel(y)/s(1),s(1));
    y = y(:,k);
end
end

function u = DiffL(u,k)
if nargin == 1, k = 1; end
u(1) = Diff(u,k,'l');
% u = Diff(u,k);
end

function u = DiffR(u,k)
if nargin == 1, k = 1; end
u(end) = Diff(u,k,'r');
% u = Diff(u,k);
end





