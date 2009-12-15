function u = pde15s( pdefun, t, u0, bc, opt)
% Solve pdes of the form u_t = pdefun(u,t,x) using chebfun.
% Toby Driscoll & Nick Hale, 2009
global order tol
order = 0; % Initialise to zero

% Default options
tol = 1e-6;             % 'eps' in chebfun terminology
doplot = 1;             % plot after every time chunk?
dohold = 0;             % plot after every time chunk?

% No options given
if nargin < 5, opt = pdeset; end

% PDE solver options
if ~isempty(opt.Eps), tol = opt.Eps; end
if ~isempty(opt.Plot), doplot = strcmpi(opt.Plot,'on'); end
if ~isempty(opt.HoldPlot), dohold = strcmpi(opt.HoldPlot,'on'); end

% ODE tolerances
atol = odeget(opt,'AbsTol',1e-6);
rtol = odeget(opt,'RelTol',1e-3);
tolflag = 0;
if tol < atol, opt = odeset(opt,'AbsTol',tol); tolflag = 1; end
if tol < rtol, opt = odeset(opt,'RelTol',tol); tolflag = 1; end
% if tolflag, 
%     warning('CHEBFUN:pde15s',['AbsTol and RelTol must be <= Tol.', ...
%         ' Adjusting accordingly.']);
% end

% If the differential operator is passed, redefine the anonymous function
% This should be the default behaviour?
if nargin(pdefun) == 2
    pdefun = @(u,t,x) pdefun(u,@Diff);
    % get the order (which is a global variable) by evaluating the RHS with [] 
    pdefun([]); % (See Diff below for more details)
elseif nargin(pdefun) == 4
    pdefun = @(u,t,x) pdefun(u,t,x,@Diff);
    pdefun([],[],[]); % (as above)
end

% some error checking on the bcs
if order > 2 && ischar(bc) && (strcmpi(bc,'neumann') || strcmpi(bc,'dirichlet'))
    error('CHEBFUN:pde15s:bcs',['Cannot assign "', bc, '" boundary conditions to a ', ...
        'RHS with differential order ', int2str(order),'.']);
end
if iscell(bc) && numel(bc) == 2
    bc = struct( 'left', bc{1}, 'right', bc{2});
end

% Set bcs to zeros (these are supplied by rhs variable in odefun)
rhs = {}; nllbc = []; nlbcfuns = {}; nlrbc = [];
if isfield(bc,'left')
    if isa(bc.left,'function_handle')
        bc.left = struct( 'op', bc.left, 'val', 0);
    end
    lop = {bc.left.op};
    % Remove nonlinear conditions
    for k = 1:numel(lop)
        if isa(lop{k},'function_handle')
            lopk = lop{k};
            if nargin(lopk) == 2,      lopk = @(u,t,x) lopk(u,@Diff);
            elseif nargin(lopk) == 4,  lopk = @(u,t,x) lopk(u,t,x,@Diff); end
            nlbcfuns = [nlbcfuns {lopk}]; nllbc = [nllbc k]; % Store
        end
    end     
    % Store RHS of bcs and set to homogenious
    if isfield(bc.left,'val')
        rhs = [rhs {bc.left.val}];  
        bc.left = struct( 'op', lop, 'val', {0});
    end
end
if isfield(bc,'right')
    if isa(bc.right,'function_handle')
        bc.right = struct( 'op', bc.right, 'val', 0);
    end
    rop = {bc.right.op};
    % Remove nonlinear conditions
    for k = 1:numel(rop)
        if isa(rop{k},'function_handle')
            ropk = rop{k};
            if nargin(ropk) == 2,      ropk = @(u,t,x) ropk(u,@Diff);
            elseif nargin(ropk) == 4,  ropk = @(u,t,x) ropk(u,t,x,@Diff); end
            nlbcfuns = [nlbcfuns {ropk}]; nlrbc = [nlrbc k]; % Store
        end
    end          
    % Store RHS of bcs and set to homogenious
    if isfield(bc.right,'val')
        rhs = [rhs {bc.right.val}];
        bc.right = struct( 'op', rop, 'val', {0});
    end
end    

% Get the domain
d = domain(u0);

% This is needed inside the nested function onestep()
diffop = diff(d,order);

% initial condition
u = simplify(u0,tol);

% The vertical scale of the intial condition
vscl = u.scl;

% Plotting setup
if doplot
    cla, shg, set(gcf,'doublebuf','on')
    plot(u,'.-'), drawnow,
    if dohold, ish = ishold; hold on, end
end

% Begin time chunks
for nt = 1:length(t)-1
    curlen = length(u(:,nt));
    u(:,nt+1) = chebfun( @(x) vscl+onestep(x), d, 'eps', tol, 'minsamples',curlen, ...
        'resampling','on','splitting','off','sampletest','off','blowup','off')-vscl;  % solve one chunk
    if doplot
        cla, plot(u(:,nt+1),'.-')
        title(sprintf('t = %.3f,  len = %i',t(nt+1),curlen)), drawnow
    end
end

if dohold && ~ish, hold off, end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    ONESTEP   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constructs the result of one time chunk at fixed discretization
    function U = onestep(y)
        global x
        x = y;
        n = length(x);
        if n == 2, U = [0;0]; return, end
        U0 = feval(u(:,nt),x);
        % See what the boundary replacement actions will be.
        [ignored,B,q,rows] = feval( diffop & bc, n, 'bc' );
        % Mass matrix is I except for algebraic rows for the BCs.
        M = speye(n);  M(rows,:) = 0;
        
        % Magic line: Convert the string spec into a working callable function
        % at the proper discretization size.
        opt = odeset(opt,'mass',M,'masssing','yes','initialslope',odefun(t(nt),U0));
        
        [ignored,U] = ode15s(@odefun,t(nt:nt+1),U0,opt);
        U = U(end,:).';
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    ODEFUN   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % This is what ode15s calls.
        function F = odefun(t,U)
            F = pdefun(U,t,x);
            for l = 1:numel(rhs)
                if isa(rhs{l},'function_handle')
                    q(l,1) = feval(rhs{l},t);
                else
                    q(l,1) = rhs{l};
                end
            end
            
            % replacements for the BC algebraic conditions
            F(rows) = B*U-q;  
            
            % replacements for the nonlinear BC conditions
            j = 0;
            for kk = 1:length(nllbc)
                j = j + 1;
                tmp = feval(nlbcfuns{j},U,t,x);
                F(rows(kk)) = tmp(1)-q(kk);
            end
            for kk = numel(rhs)+1-nlrbc
                j = j + 1;
                tmp = feval(nlbcfuns{j},U,t,x);
                F(rows(kk)) = tmp(end)-q(kk);
            end
           
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   DIFF   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% The differential operators
function up = Diff(u,k)
    % Computes the k-th derivative of u using Chebyshev differentiation
    % matrices defined by barymat. The matrices are stored for speed.
    
    global x order
    persistent storage
    if isempty(storage), storage = struct([]); end

    % Assume first-order derivative
    if nargin == 1, k = 1; end

    N = length(u);
    
    % For finding the order of the RHS
    if N == 0, 
        if isempty(order), order = k;
        else order = max(order,k); end
        up = [];
        return
    end

    % Retrieve or compute matrix.
    if N > 5 && length(storage) >= N && numel(storage(N).D)>=k ...
            && ~isempty(storage(N).D{k})
        % Matrix is already in storage
    else
        % Which differentiation matrices do we need?
        switch order
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
    up = storage(N).D{k}*u;
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

if nargin < 2           % Default to Chebyshev weights
    w = [.5 ; ones(N,1)]; 
    w(2:2:end) = -1;
    w(end) = .5*w(end);
end

ii = (1:N+2:(N+1)^2)';
Dw = repmat(w',N+1,1) ./ repmat(w,1,N+1) - eye(N+1);
Dx = repmat(x ,1,N+1) - repmat(x',N+1,1) + eye(N+1);

D1 = Dw ./ Dx;
D1(ii) = 0; D1(ii) = - sum(D1,2);
if (nargout == 1), varargout = {D1}; return; end
D2 = 2*D1 .* (repmat(D1(ii),1,N+1) - 1./Dx);
D2(ii) = 0; D2(ii) = - sum(D2,2);
if (nargout == 2), return; end
D3 = 3./Dx .* (Dw.*repmat(D2(ii),1,N+1) - D2);
D3(ii) = 0; D3(ii) = - sum(D3,2);
if (nargout == 3), return; end
D4 = 4./Dx .* (Dw.*repmat(D3(ii),1,N+1) - D3);
D4(ii) = 0; D4(ii) = - sum(D4,2);
end























