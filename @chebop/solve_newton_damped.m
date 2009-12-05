function [u nrmduvec] = solve_newton_damped(N,rhs)
% Damped Newton iteration. More details will follow very soon.

% Begin by obtaining the nonlinop preferences
pref = cheboppref;
restol = pref.restol;
deltol = pref.deltol;
maxIter = pref.maxiter;
sigma = 0.01; lambda_min = 0.1; tau = 0.1;

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
% whether we have a chebop, if so, perform subtraction otherwise.
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

% Check whether either boundary has no BC attached, used later in the
% iteration.
leftEmpty = isempty(bcFunLeft);
rightEmpty = isempty(bcFunRight);

% Construct initial guess if missing
if isempty(N.guess) % No initial guess given
    if isempty(N.dom)
        error('Error in nonlinear backslash. Neither domain nor initial guess is given')
    else
        dom = N.dom;
        u = findguess(N);% Initial quasimatrix guess of 0 functions chebfun(0,dom);
    end
else
    u = N.guess;
    dom = domain(u);
end

ab = dom.ends;
a = ab(1);  b = ab(end);

if ~iscell(bcFunLeft), bcFunLeft = {bcFunLeft}; end
if ~iscell(bcFunRight), bcFunRight = {bcFunRight}; end

counter = 0;

% Anon. fun. and chebops differ whether we use N(u) or L*u
if opType == 1
    r = problemFun(u);
else
    r = problemFun*u;
end
nrmdu = Inf;
normr = Inf;
nrmduvec = zeros(10,1);
lambdas = zeros(10,1);
while nrmdu > restol && normr > deltol && counter < maxIter
    counter = counter +1;
    %     u = jacvar(u);
    % Check whether a boundary happens to have no BC attached
    if leftEmpty
        bc.left = [];
    else
        for j = 1:length(bcFunLeft)
            v = bcFunLeft{j}(u);
            bc.left(j) = struct('op',diff(v,u),'val',v(a));
        end
    end
    % Check whether a boundary happens to have no BC attached
    if rightEmpty
        bc.right = [];
    else
        for j = 1:length(bcFunRight)
            v = bcFunRight{j}(u);
            bc.right(j) = struct('op',diff(v,u),'val',v(b));
        end
    end
    % If the operator is a chebop, we don't need to linearize. Else, do the
    % linearization using diff. Note that if the operator is a chebop, we
    % handle the rhs differently.
    if opType == 1
        A = diff(r,u) & bc;
        subsasgn(A,struct('type','.','subs','scale'), sqrt(sum( sum(u.^2,1))));
        delta = -(A\r);  
    else
        A = problemFun & bc; % problemFun is a chebop
        A.scale = sqrt(sum( sum(u.^2,1)));
        delta = -(A\(r-rhs));
    end
    

    
%     alpha = fminbnd(g,0.1,1)
    lambda = optStep;
    
    u = u + lambda*delta;
    u = jacvar(u);      % Reset the Jacobian of the function
    
    if opType == 1
        r = problemFun(u);
    else
        r = problemFun*u;
    end
    
    
    nrmdu = norm(delta,'fro');
    normr = solNorm;
    %     nrmdu = sqrt(sum( sum(delta.^2,1)));
    %     normr = sqrt(sum( sum(r.^2,1)));
    % In case of a quasimatrix, the norm calculations are taking the
    % longest time in each iterations. This is caused by the fact that we
    % are performing svd in the norm calculations in case of quasimatrices.
    % A possible remedy would be to the simply take the inner product
    % columnwise and use the sum of those inner products as an estimate for
    % the residuals (this is certainly correct if the preferred norm would
    % be the Frobenius norm).
    if strcmp(pref.plotting,'on')
        subplot(2,1,1),plot(u);title('Current solution');
        subplot(2,1,2),plot(delta,'r'),title('Latest update');
        drawnow,pause
    end

    nrmduvec(counter) = nrmdu;
    lambdas(counter) = lambda;
end

% Function that measures how far away we are from the solving the BVP.
% This function takes into account the differential equation and the
% boundary values.
    function sn = solNorm()
        sn = 0;
        if ~leftEmpty
            for bcCount = 1:length(bcFunLeft)
                v = bcFunLeft{bcCount}(u);
                sn = sn + v(a)^2;
            end
        end
        % Check whether a boundary happens to have no BC attached
        if rightEmpty
            bc.right = [];
        else
            for bcCount = 1:length(bcFunRight)
                v = bcFunRight{bcCount}(u);
                sn = sn + v(b)^2;
            end
        end
        
        if opType == 1
            sn = sn + norm(r,'fro').^2;
        else
            sn = sn + norm(r-rhs,'fro').^2;
        end
        

        sn = sqrt(sn);

    end

    function lam = optStep()        
        g = @(a) 0.5*norm(A\problemFun(u+a*delta)).^2;
        g0 = g(0)
%         
        % Check whether the full Newton step is acceptable. If not, we
        % search for a mininum using fminbnd.
%         g1 = g(1);
%         if g1 < (1-2*sigma)*g0
%             lam = 1;
%         else          
%             amin = fminbnd(g,0.1,1);
%             lam = amin;
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
        if lam < lambda_min
            disp('Use min lambda')
            lam = lambda_min;
        end

    end
            

% Clear up norm vector
nrmduvec(counter+1:end) = [];
lambdas
end
