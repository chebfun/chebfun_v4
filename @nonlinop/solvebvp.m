function [u nrmduvec] = solvebvp(BVP,rhs)
% Begin by obtaining the nonlinop preferences
pref = nonlinoppref;
tol = pref.tolerance;

% Check whether the operator is empty, or whether both BC are empty
if isempty(BVP.op)
    error('Operator empty');
end

if isempty(BVP.lbc) && isempty(BVP.rbc)
    error('Both BC empty');
end

% Check which type the operator is (anonymous function or a chebop).
% If it's an anonymous function, opType = 1. Else, opType = 2.
if strcmp(BVP.optype,'an_fun')
    opType = 1;
else
    opType = 2;
end

% If RHS of the \ is 0, keep the original DE. If not, update it
if isnumeric(rhs) && rhs == 0
    problemFun = BVP.op;
else
    problemFun = @(u) BVP.op(u)-rhs;
end

% Extract BC functions
bcFunLeft = BVP.lbc;
bcFunRight = BVP.rbc;

% Check whether either boundary has no BC attached, used later in the
% iteration.
leftEmpty = isempty(bcFunLeft);
rightEmpty = isempty(bcFunRight);



% Construct initial guess if missing
if isempty(BVP.guess) % No initial guess given
    if isempty(BVP.dom)
        error('Error in nonlinear backslash. Neither domain nor initial guess is given')
    else
        dom = BVP.dom;
        u = chebfun(0,dom);
    end
else
    u = BVP.guess;
    dom = domain(u);
end

ab = dom.ends;
a = ab(1);  b = ab(end);

if ~iscell(bcFunLeft), bcFunLeft = {bcFunLeft}; end
if ~iscell(bcFunRight), bcFunRight = {bcFunRight}; end

counter = 0;
% u = jacvar(u);

% An. fun. and chebops differ whether we do N(u) or L*u
if opType == 1
    r = problemFun(u);
else
    r = problemFun*u;
end
nrmdu = Inf;
normr = Inf;
nrmduvec = zeros(10,1);
alpha = 1;      % Stepsize in Newton iteration
while nrmdu > tol && normr > tol
    %     u = jacvar(u);
    % Check whether a boundary happens to have no BC attached
    if leftEmpty
        bc.left = [];
    else
        for j = 1:length(bcFunLeft) - isempty(bcFunLeft{1})
            v = bcFunLeft{j}(u);
            bc.left(j) = struct('op',jacobian(v,u),'val',v(a));
        end
    end
    % Check whether a boundary happens to have no BC attached
    if rightEmpty
        bc.right = [];
    else
        for j = 1:length(bcFunRight)
            v = bcFunRight{j}(u);
            bc.right(j) = struct('op',jacobian(v,u),'val',v(b));
        end
    end
    % If the operator is a chebop, we don't need to linearize. Else, do the
    % linearization using diff
    if opType == 1
        A = diff(r,u) & bc;
    else
        A = problemFun & bc; % problemFun is a chebop
    end
    A.scale = sqrt(sum( sum(u.^2,1)));
    delta = -(A\r);
    
    
    
    u = u + alpha*delta;
    u = jacvar(u);      % Reset the Jacobian of the function
    
    if opType == 1
        r = problemFun(u);
    else
        r = problemFun*u;
    end
    
    
    nrmdu = norm(delta,'fro');
    normr = norm(r,'fro');
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
    counter = counter +1;
    %     if nrmdu < 1e-1
    %         alpha  = 1
    %     end
    nrmduvec(counter) = nrmdu;
end

end
