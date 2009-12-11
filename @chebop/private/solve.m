function [u nrmduvec] = solve(N,rhs)
% SOLVE. Version at 16:46, 5/12/2009

% Begin by obtaining the nonlinop preferences
pref = cheboppref;
restol = pref.restol;
deltol = pref.deltol;
maxIter = pref.maxiter;
maxStag = pref.maxstagnation;
currEps = chebfunpref('eps');


% Check whether the operator is empty, or whether both BC are empty
if isempty(N.op)
    error('Operator empty');
end

if isempty(N.lbc) && isempty(N.rbc)
    error('Both BC empty');
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
    error('Nonlinop:mldivide:findguess: BC is periodic at one end but not at the other.');
end

% Check whether either boundary has no BC attached, used later in the
% iteration.
leftEmpty = isempty(bcFunLeft);
rightEmpty = isempty(bcFunRight);

% Construct initial guess if missing
if isempty(N.guess) % No initial guess given
    if isempty(N.dom)
        error('chebop:solve:noGuess','Neither domain nor initial guess is given.')
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
normr = Inf;
nrmduvec = zeros(10,1);
normrvec = zeros(10,1);

lambda = 1;      % Stepsize in Newton iteration - Pure Newton so stepsize is 1
stagCounter = 0; % Counter that checks whether we are stagnating
normu = norm(u,'fro'); % Initial value for normu (used for accuracy settings)

solve_display('init',u);



while nrmdu > deltol && norm(normr) > restol && counter < maxIter && stagCounter < maxStag
    counter = counter +1;
    
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
        else
            try
                % Lowering tolerance of chebfun constructor (so not to use the
                % default tolerance of chebfuns but rather a size related to the
                % norm of u and the tolerance requested).
                newEps = deltol;
                chebfunpref('eps',newEps);
                delta = -(A\r);
                chebfunpref('eps',currEps);
            catch
                chebfunpref('eps',currEps);
            end
        end
    else
        A = problemFun & bc; % problemFun is a chebop
        subsasgn(A,struct('type','.','subs','scale'), sqrt(sum( sum(u.^2,1))));
        delta = -(A\(r-rhs));
    end
    
    u = u + lambda*delta;
    
    u = jacvar(u);      % Reset the Jacobian of the function
    
    r = problemFun(u);
    
    normu = norm(u,'fro');
    nrmdu = norm(delta,'fro')/normu;
    normr = solNorm/normu;
    
    % In case of a quasimatrix, the norm calculations were taking the
    % longest time in each iterations when we used the two norm.
    % This was caused by the fact that we performed
    % svd in the norm calculations in case of quasimatrices.
    % A possible remedy was be to the simply take the inner product
    % columnwise and use the sum of those inner products as an estimate for
    % the residuals (this is certainly correct if the preferred norm is
    % be the Frobenius norm).
    
    solve_display('iter',u,lambda*delta,nrmdu,normr)
      
    nrmduvec(counter) = nrmdu;
    normrvec(counter) = norm(normr);
    
end
% Clear up norm vector
nrmduvec(counter+1:end) = [];
solve_display('final',u,[],nrmdu,normr)

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
    function sn = solNorm()
        sn = [0 0];
        
        if strcmpi(bcFunLeft,'periodic')
            diffOrderA = struct(A).difforder;
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

end
