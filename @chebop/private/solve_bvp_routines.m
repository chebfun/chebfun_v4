function [u nrmduvec] = solve_bvp_routines(N,rhs)
% SOLVE_BVP_ROUTINES Private function of the chebop class.
%
% This function gets called by nonlinear backslash and solvebvp. It both
% treates the cases where the user requests damped Newton iteration and
% pure Newton iteration.


% Damped Newton iteration. More details will follow.

% Begin by obtaining the nonlinop preferences
pref = cheboppref;
restol = pref.restol;
deltol = pref.deltol;
maxIter = pref.maxiter;
maxStag = pref.maxstagnation;
dampedOn = strcmpi(pref.damped,'on');
lambda_minCounter = 0;

% Check whether the operator is empty, or whether both BC are empty
if isempty(N.op)
    error('CHEBOP:solve_bvp_routines:OpEmpty','Operator empty');
end

if isempty(N.lbc) && isempty(N.rbc)
    error('CHEBOP:solve_bvp_routines:BCEmpty''Both BC empty');
end

% Check which type the operator is (anonymous function or a chebop).
% If it's an anonymous function, opType = 1. Else, opType = 2.
if strcmp(N.optype,'anon_fun')
    opType = 1;
else
    opType = 2;
end

% If RHS of the \ is 0, keep the original DE. If not, update it. Also check
% whether we have a chebop, if so, perform subtraction in a different way.
if opType == 2  % Operator is a chebop. RHS is treated later
    problemFun = N.op;
elseif isnumeric(rhs) && all(rhs == 0)
    problemFun = N.op;
else
    problemFun = @(u) N.op(u)-rhs;
end

% Extract BC functions
bcFunLeft = N.lbc;
bcFunRight = N.rbc;

if xor(strcmpi(bcFunLeft,'periodic'),strcmpi(bcFunRight,'periodic'))
    error('CHEBOP:solve_bvp_routines:findguess', 'BC is periodic at one end but not at the other.');
end

% Check whether either boundary has no BC attached, used later in the
% iteration.
leftEmpty = isempty(bcFunLeft);
rightEmpty = isempty(bcFunRight);

% Construct initial guess if missing
if isempty(N.guess) % No initial guess given
    if isempty(N.dom)
        error('CHEBOP:solve_bvp_routines:noGuess','Neither domain nor initial guess is given.')
    else
        dom = N.dom;
        u = findguess(N); % Initial quasimatrix guess of linear chebfuns
    end
else
    u = N.guess;
    dom = domain(u);
end

ab = dom.ends;
a = ab(1);  b = ab(end);

% Wrap the BCs in a cell
if ~iscell(bcFunLeft), bcFunLeft = {bcFunLeft}; end
if ~iscell(bcFunRight), bcFunRight = {bcFunRight}; end

counter = 0;

% Anon. fun. and linops now both work with N(u)
r = problemFun(u);

nrmdu = Inf;
nnormr = Inf;
nrmduvec = zeros(10,1);
normrvec = zeros(10,1);

lambdas = zeros(10,1);
% Counter that checks whether we are stagnating. If we are doing pure
% Newton iteration, this counter will remain 0.
stagCounter = 0;
if dampedOn
    solve_display('initNewton',u);
else
    solve_display('init',u);
end

while nrmdu > deltol && nnormr > restol && counter < maxIter && stagCounter < maxStag
    counter = counter + 1;
    
    bc = setupBC();
    % If the operator is a chebop, we don't need to linearize. Else, do the
    % linearization using diff. Note that if the operator is a chebop, we
    % need to handle the rhs differently.
    if opType == 1
        A = diff(r,u) & bc;
        
        % Using A.scale if we are in the first iteration - Handles linear
        % problems better
        if counter == 1
            subsasgn(A,struct('type','.','subs','scale'), norm(u,'fro'));
            delta = -(A\r);
            % After the first iteration, we lower the tolerance of the chebfun
            % constructor (so not to use the default tolerance of chebfuns
            % but rather a size related to the tolerance requested).
        else
            % Linop backslash with the third argument added
            delta = -mldivide(A,r,deltol);
        end
    else
        A = problemFun & bc; % problemFun is a chebop
        
        % Do similar tricks as above for the tolerances.
        if counter == 1
            subsasgn(A,struct('type','.','subs','scale'), norm(u,'fro'));
            delta = -(A\(r-rhs));
        else
            delta = -mldivide(A,r-rhs,deltol);
        end
    end
    
    % Find the optimal stepsize of the dampe Newton iteration
    if dampedOn
        lambda = optStep();
    else
        lambda = 1;
    end
    
    % Add the correction to the current solution
    u = u + lambda*delta;
    u = jacvar(u);      % Reset the Jacobian of the function
    
    r = problemFun(u);
    
    normu = norm(u,'fro');
    nrmdu = norm(delta,'fro')/normu;
    normr = solNorm/normu;
    nnormr = norm(normr);
    
    % In case of a quasimatrix, the norm calculations were taking the
    % longest time in each iterations when we used the two norm.
    % This was caused by the fact that we performed
    % svd in the norm calculations in case of quasimatrices.
    % A possible remedy was be to the simply take the inner product
    % columnwise and use the sum of those inner products as an estimate for
    % the residuals (this is certainly correct if the preferred norm is
    % be the Frobenius norm).
    nrmduvec(counter) = nrmdu;
    normrvec(counter) = nnormr/normu;
    lambdas(counter) = lambda;
    
    % We want a slightly different output when we do a damped Newton
    % iteration. Also, in damped Newton, we check for stagnation.
    if dampedOn
        solve_display('iterNewton',u,lambda*delta,nrmdu,normr,lambda)
        stagCounter = checkForStagnation(stagCounter);
    else
        solve_display('iter',u,lambda*delta,nrmdu,normr)
    end
end
% Clear up norm vector
nrmduvec(counter+1:end) = [];
solve_display('final',u,[],nrmdu,normr)

% Issue a warning message if stagnated. Should this in output argument
% (i.e. flag)?
if stagCounter == maxStag
    warning('CHEBOP:Solvebvp', 'Function exited with stagnation flag.')
end

% Function that sets up the boundary conditions of the linearized operator
    function bcOut = setupBC()
        % If we have a periodic BC, simply let bc be 'periodic'. We have
        % already checked whether both left and right BCs are both periodic
        % or not, so no need to check both left and right.
        if strcmpi(bcFunLeft,'periodic')
            bcOut = 'periodic';
        else
            % Check whether a boundary happens to have no BC attached
            if leftEmpty
                bcOut.left = [];
            else
                for j = 1:length(bcFunLeft)
                    v = bcFunLeft{j}(u);
                    bcOut.left(j) = struct('op',diff(v,u),'val',v(a));
                end
            end
            % Check whether a boundary happens to have no BC attached
            if rightEmpty
                bcOut.right = [];
            else
                for j = 1:length(bcFunRight)
                    v = bcFunRight{j}(u);
                    bcOut.right(j) = struct('op',diff(v,u),'val',v(b));
                end
            end
        end
    end

% Function that measures how far away we are from the solving the BVP.
% This function takes into account the differential equation and the
% boundary values.
    function sn = solNorm
        sn = [0 0];
        
        % Need to check whether we satisfy BCs in a different way if we
        % have periodic BCs (i.e. we check for example whether u(0) = u(1),
        % u'(0) = u'(1) etc.).
        if strcmpi(bcFunLeft,'periodic')
%             diffOrderA = struct(A).difforder;
            for orderCounter = 0:diffOrderA - 1
                sn(2) = sn(2) + norm(feval(diff(u,orderCounter),b)-feval(diff(u,orderCounter),a))^2;
            end
        else
            
            if ~leftEmpty
                for bcCount = 1:length(bcFunLeft)
                    v = bcFunLeft{bcCount}(u);
                    sn(2) = sn(2) + v(a)^2;
                end
            end
            
            % Check whether a boundary happens to have no BC attached
            if rightEmpty
                bc.right = [];
            else
                for bcCount = 1:length(bcFunRight)
                    v = bcFunRight{bcCount}(u);
                    sn(2) = sn(2) + v(b)^2;
                end
            end
        end
        
        if opType == 1
            sn(1) = sn(1) + norm(r,'fro').^2;
        else
            sn(1) = sn(1) + norm(r-rhs,'fro').^2;
        end
        
        sn = sqrt(sn);
    end

    function lam = optStep()
        % Parameters for damping. Eventually, they will be available for
        % the user to set in options.
        sigma = 0.01; lambda_min = 0.1; tau = 0.1;
        
        % The objective function we want to minimize.
        g = @(a) 0.5*norm(A\problemFun(u+a*delta),'fro').^2;
        g0 = g(0);
        
        % Check whether the full Newton step is acceptable. If not, we
        % search for a mininum using fminbnd.
        %         g1 = g(1);
        %         if g1 < (1-2*sigma)*g0
        %             lam = 1;
        %         else
        %             amin = fminbnd(g,0.095,1);
        %             lam = amin;
        %         end
        %         if lam < lambda_min
        %             if lambda_minCounter < 3
        %                 lambda_minCounter = lambda_minCounter + 1;
        %                 lam = lambda_min;
        %             else
        %                 %If we take three smallest step in a row, give the
        %                 %solution process a "kick".
        %                 lam = .6;
        %                 lambda_minCounter = lambda_minCounter - 1;
        %             end
        %         end
        %
        % Explicit calculations, see Ascher, Mattheij, Russell [1995]
        
        lam = 1;
        accept = 0;
        while ~accept && lam > lambda_min
            glam = g(lam);
            if glam <= (1-2*lam*sigma)*g0
                accept = 1;
            else
                lam = max(tau*lam,(lam^2*g0)/((2*lam-1)*g0+glam));
            end
        end
        if lam <= lambda_min
            if lambda_minCounter < 3
                lambda_minCounter = lambda_minCounter + 1;
                lam = lambda_min;
            else
                % If we take three smallest step in a row, give the
                % solution process a "kick".
                lam = 1;
                lambda_minCounter = lambda_minCounter - 1;
            end
        end
    end

% Function used in the stagnation check for damped Newton iteration.
    function updatedStagCounter = checkForStagnation(currStagCounter)
        if nrmdu > min(nrmduvec(1:counter)) && norm(normr)/normu > min(normrvec(1:counter))
            updatedStagCounter = currStagCounter+1;
        else
            updatedStagCounter = max(0,currStagCounter-1);
        end
    end
end