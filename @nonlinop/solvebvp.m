function [u nrmduvec] = solvebvp(BVP,rhs)
% Should do check whether any of these fields are empty
pref = nonlinoppref;
problemFun = @(u) BVP.op(u)-rhs;
bcFunLeft = BVP.lbc;
bcFunRight = BVP.rbc;
tol = 1e-10;

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
    
% % Construct initial guess if missing
% if isa(dom,'domain')
%     u = chebfun(0,dom);
% else
%     u = dom;
%     dom = domain(u);
% end

ab = dom.ends;
a = ab(1);  b = ab(end);

if ~iscell(bcFunLeft), bcFunLeft = {bcFunLeft}; end
if ~iscell(bcFunRight), bcFunRight = {bcFunRight}; end

counter = 0;
% u = jacvar(u);
r = problemFun(u);
nrmdu = Inf;
normr = Inf;
nrmduvec = [];
alpha = 1;      % Stepsize in Newton iteration
while nrmdu > tol && normr > tol
%     u = jacvar(u);
    for j = 1:length(bcFunLeft)
        v = bcFunLeft{j}(u);
        bc.left(j) = struct('op',jacobian(v,u),'val',v(a));
    end
    for j = 1:length(bcFunRight)
        v = bcFunRight{j}(u);
        bc.right(j) = struct('op',jacobian(v,u),'val',v(b));
    end
    A = jacobian(r,u) & bc;
    A.scale = sqrt(sum( sum(u.^2,1)));
    delta = -(A\r);
    

    
    u = u + alpha*delta;
    u = jacvar(u);      % Reset the Jacobian of the function
    r = problemFun(u);
    

    nrmdu = norm(delta,'fro');
    normr = norm(r,2);
%     nrmdu = sqrt(sum( sum(delta.^2,1)));
%     normr = sqrt(sum( sum(r.^2,1)));
    % In case of a quasimatrix, the norm calculations are taking the
    % longest time in each iterations. This is caused by the fact that we
    % are performing svd in the norm calculations in case of quasimatrices.
    % A possible remedy would be to the simply take the inner product
    % columnwise and use the sum of those inner products as an estimate for
    % the residuals (this is certainly correct if the preferred norm would
    % be the Frobenius norm).
    %     u = chebfun(@(y) u(y)+delta(y),d);
    if pref.plotting == 1 
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
% disp(['Converged in ', num2str(counter), ' iterations']);
% toc;
end
