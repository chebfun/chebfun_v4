function [u nrmduvec] = solvebvp(N,rhs)
% Begin by obtaining the nonlinop preferences
pref = cheboppref;
restol = pref.restol;
deltol = pref.deltol;
maxIter = pref.maxiter;
maxStag = pref.maxstag;
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
        error('chebop:solvebvp:noGuess','Neither domain nor initial guess is given.')
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
normrvec = zeros(10,1);

alpha = 1;      % Stepsize in Newton iteration
stagCounter = 0; % Counter that checks whether we are stagnating
normu = norm(u,'fro'); % Initial value for normu (used for accuracy settings)
while nrmdu > deltol && normr > restol && counter < maxIter && stagCounter < maxStag
    counter = counter +1;
    
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
        
        % Using A.scale
%         subsasgn(A,struct('type','.','subs','scale'), sqrt(sum( sum(u.^2,1))));
%         delta = -(A\r);     
%        
        % Lowering tolerance of chebfun constructor (so not to use the
        % default tolerance of chebfuns but rather a size related to the
        % norm of u and the tolerance requested).
        newEps = normu*deltol
        chebfunpref('eps',newEps);
        
        delta = -(A\r);
        chebfunpref('eps',currEps);
        
    else
        A = problemFun & bc; % problemFun is a chebop
        subsasgn(A,struct('type','.','subs','scale'), sqrt(sum( sum(u.^2,1))));
        %A.scale = sqrt(sum( sum(u.^2,1)));
        delta = -(A\(r-rhs));
    end
    
%     delta = simplify(delta,deltol);
    u = u + alpha*delta;
    
    u = jacvar(u);      % Reset the Jacobian of the function
    
    if opType == 1
        r = problemFun(u);
    else
        r = problemFun*u;
    end
    
    normu = norm(u,'fro')
    nrmdu = norm(delta,'fro')/normu
    normr = solNorm/normu
    %     nrmdu = sqrt(sum( sum(delta.^2,1)));
    %     normr = sqrt(sum( sum(r.^2,1)));
    % In case of a quasimatrix, the norm calculations are taking the
    % longest time in each iterations. This is caused by the fact that we
    % are performing svd in the norm calculations in case of quasimatrices.
    % A possible remedy would be to the simply take the inner product
    % columnwise and use the sum of those inner products as an estimate for
    % the residuals (this is certainly correct if the preferred norm would
    % be the Frobenius norm).
    
    
    u = simplify(u,deltol*norm(u,'fro'));
    
    if strcmp(pref.plotting,'on')
        subplot(2,1,1),plot(u,'.-');title('Current solution');
        subplot(2,1,2),plot(delta,'.-r'),title('Latest update');
        drawnow,pause
    end

    nrmduvec(counter) = nrmdu;
    normrvec(counter) = normr;
    
    
    % Avoid stagnation.
    if nrmdu > min(nrmduvec(1:counter)) && normr > min(normrvec(1:counter))
        stagCounter = stagCounter+1;
    else
        stagCounter = max(0,stagCounter-1);
    end
end
% Clear up norm vector
nrmduvec(counter+1:end) = [];

% Issue a warning message if stagnated. Should this in output argument
% (i.e. flag)?
if stagCounter == maxStag
    warning('Nonlinop:Solvebvp: Function exited with stagnation flag.')
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


end
