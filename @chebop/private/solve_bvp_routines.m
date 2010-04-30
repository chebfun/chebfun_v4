function [u nrmduvec] = solve_bvp_routines(N,rhs,options,guihandles)
% SOLVE_BVP_ROUTINES Private function of the chebop class.
%
% This function gets called by nonlinear backslash and solvebvp. It both
% treates the cases where the user requests damped Newton iteration and
% pure Newton iteration.


% Damped Newton iteration. More details will follow.

% If no options are passed, obtain the the nonlinop preferences
switch nargin
    case 2
        pref = cheboppref;
        guihandles = [];
    case 3
        pref = options;
        guihandles = [];
    case 4
        pref = options;
end

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
% The variable numberOfInputVariables is a flag that's used to evaluate
% functions in the function evalProblemFun.
if opType == 2  % Operator is a chebop. RHS is treated later
    deFun = N.op;
    numberOfInputVariables = 1;
elseif isnumeric(rhs) && all(rhs == 0)
    deFun = N.op;
    numberOfInputVariables = nargin(deFun);
else
    deFun = @(u) N.op(u)-rhs;
    numberOfInputVariables = nargin(deFun);
end

% Create the variable currentGuessCell which is used for evaluation anon.
% function with multiple input variables
currentGuessCell = [];

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

% Wrap the DE and BCs in a cell
% if ~iscell(deFun), deFun = {deFun}; end
% if ~iscell(bcFunLeft), bcFunLeft = {bcFunLeft}; end
% if ~iscell(bcFunRight), bcFunRight = {bcFunRight}; end

counter = 0;

% Anon. fun. and linops now both work with N(u)
% r = deFun(u);
r = evalProblemFun('DE',u);

nrmdu = Inf;
nnormr = Inf;
nrmduvec = zeros(10,1);
normrvec = zeros(10,1);

lambdas = zeros(10,1);
% Counter that checks whether we are stagnating. If we are doing pure
% Newton iteration, this counter will remain 0.
stagCounter = 0;
if dampedOn
    solve_display(pref,guihandles,'initNewton',u);
else
    solve_display(pref,guihandles,'init',u);
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
        A = deFun & bc; % deFun is a chebop
        
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
    u = jacreset(u);      % Reset the Jacobian of the function
    
    % Reset the currentGuessCell variable
    currentGuessCell = [];
    
    %     r = deFun(u);
    r = evalProblemFun('DE',u);
    
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
        solve_display(pref,guihandles,'iterNewton',u,lambda*delta,nrmdu,normr,lambda)
        stagCounter = checkForStagnation(stagCounter);
    else
        solve_display(pref,guihandles,'iter',u,lambda*delta,nrmdu,normr)
    end
    
    % If the user has pressed the stop button on the GUI, we stop and
    % return the latest solution
    if nargin == 4 && strcmpi(get(guihandles{6},'Enable'),'Off')
        nrmduvec(counter+1:end) = [];
        solve_display(pref,guihandles,'final',u,[],nrmdu,normr)
        return
    end
    
end
% Clear up norm vector
nrmduvec(counter+1:end) = [];
solve_display(pref,guihandles,'final',u,[],nrmdu,normr)

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
                v = evalProblemFun('LBC',u);
                for j = 1:numel(v);
                    bcOut.left(j) = struct('op',diff(v(:,j),u),'val',v(a,j));
                end
            end
            % Check whether a boundary happens to have no BC attached
            if rightEmpty
                bcOut.right = [];
            else
                v = evalProblemFun('RBC',u);
                for j = 1:numel(v);
                    bcOut.right(j) = struct('op',diff(v(:,j),u),'val',v(b,j));
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
            % Evaluate residuals of BCs
            if ~leftEmpty
                v = evalProblemFun('LBC',u);
                sn(2) = sn(2) + v(a,:)*v(a,:)';
            end
            
            if ~rightEmpty
                v = evalProblemFun('RBC',u);
                sn(2) = sn(2) + v(b,:)*v(b,:)';
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
        
        % This objective function does not take into account BCs.
        g = @(a) 0.5*norm(A\deFun(u+a*delta),'fro').^2;
        
        % Objective function with BCs - Using the functions.
        g = @(a) 0.5*(norm(A\evalProblemFun('DE',u+a*delta),'fro').^2 +bcResidual(u+a*delta));
        
        % Objective function with BCs - Using linearized BCs
        %         g = @(a) 0.5*(norm(A\deFun(u+a*delta),'fro').^2 +bcResidual2(u+a*delta));
        %          g = @(a) 0.5*(norm(A\deFun(u+a*delta),'fro').^2 + ...
        %             norm(bcLeftOp\(deFun(u+a*delta),'fro').^2);
        %         g = @(a) 0.5*(norm(deFun(u+a*delta),'fro').^2 +bcResidual(u+a*delta));
        g0 = g(0);
        
        % Check whether the full Newton step is acceptable. If not, we
        % search for a mininum using fminbnd.
        %                 g1 = g(1);
        %                 if g1 < (1-2*sigma)*g0
        %                     lam = 1;
        %                 else
        %                     amin = fminbnd(g,0.095,1);
        %                     lam = amin;
        %                 end
        %                 if lam < lambda_min
        %                     if lambda_minCounter < 3
        %                         lambda_minCounter = lambda_minCounter + 1;
        %                         lam = lambda_min;
        %                     else
        %                         %If we take three smallest step in a row, give the
        %                         %solution process a "kick".
        %                         lam = .6;
        %                         lambda_minCounter = lambda_minCounter - 1;
        %                     end
        %                 end
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

    function bcRes = bcResidual(currentGuess)
        bcRes = 0;
        if ~leftEmpty
            v = evalProblemFun('LBC',currentGuess);
            bcRes = bcRes + v(a,:)*v(a,:)';
        end
        
        if ~rightEmpty
            v = evalProblemFun('RBC',currentGuess);
            bcRes = bcRes + v(b,:)*v(b,:)';
        end
    end

    function bcRes2 = bcResidual2(currentGuess)
        bcRes2 = 0;
        bcLeftOp = bc.left.op;
        bcLeftVal = bc.left.val;
        bcRightOp = bc.right.op;
        bcRightVal = bc.right.val;
        
        vl = bcFunLeft{1}(currentGuess);
        wl = bcLeftOp\(vl-bcLeftVal);
        bcRes2 = bcRes2 + wl(a)^2;
        
        vr = bcFunRight{1}(currentGuess);
        wr = bcRightOp\(vr-bcRightVal);
        bcRes2 = bcRes2 + wr(a)^2;
    end

    function fOut = evalProblemFun(type,currentGuess)
        % Don't need to take any special measurements if the number of
        % input arguments is not greater than 1.
        
        % We have already created a flag which tells us whether the
        % anonymous functions in the problem take one argument (i.e. a
        % whole quasimatrix) or more (e.g. @(u,v)). In the former case,
        % no special measurements have to be taken, but in the latter, in
        % order to allow evaluation, we need to create a cell array with
        % entries equal to each column of the quasimatrix representing the
        % current solution.
        
        if numberOfInputVariables == 1
            switch type
                case 'DE'
                    fOut = deFun(currentGuess);
                case 'LBC'
                    if ~iscell(bcFunLeft)
                        fOut = bcFunLeft(currentGuess);
                    else
                        fOut = chebfun;
                        for funCounter = 1:length(bcFunLeft)
                            fOut(:,funCounter) = feval(bcFunLeft{funCounter},currentGuess);
                        end
                    end
                case 'RBC'
                    if ~iscell(bcFunRight)
                        fOut = bcFunRight(currentGuess);
                    else
                        fOut = chebfun;
                        for funCounter = 1:length(bcFunRight)
                            fOut(:,funCounter) = feval(bcFunRight{funCounter},currentGuess);
                        end
                    end
            end
        else
            % Load the cell variable
            if isempty(currentGuessCell)
                currentGuessCell = cell(1,numel(currentGuess));
                for quasiCounter = 1:numel(currentGuess)
                    currentGuessCell{quasiCounter} = currentGuess(:,quasiCounter);
                end
            end
            
            switch type
                case 'DE'
                    fOut = deFun(currentGuessCell{:});
                case 'LBC'
                    fOut = bcFunLeft(currentGuessCell{:});
                case 'RBC'
                    fOut = bcFunRight(currentGuessCell{:});
            end
        end
    end


end