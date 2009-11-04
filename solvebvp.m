function [u nrmduvec] = solvebvp(problemFun,bcFun,dom,tol)
%% Solving the BVP with AD
% tic;

if nargin < 4, tol = 1e-10; end

% Construct initial guess if missing
if isa(dom,'domain')
    u = chebfun(0,dom);
else
    u = dom;
    dom = domain(u);
end

ab = dom.ends;
a = ab(1);  b = ab(end);

if ~iscell(bcFun.left), bcFun.left = {bcFun.left}; end
if ~iscell(bcFun.right), bcFun.right = {bcFun.right}; end

counter = 0;
% u = jacvar(u);
r = problemFun(u);
nrmdu = Inf;
normr = Inf;
nrmduvec = [];
alpha = 1;      % Stepsize in Newton iteration
while nrmdu > tol && normr > tol
%     u = jacvar(u);
    for j = 1:length(bcFun.left)
        v = bcFun.left{j}(u);
        bc.left(j) = struct('op',jacobian(v,u),'val',v(a));
    end
    for j = 1:length(bcFun.right)
        v = bcFun.right{j}(u);
        bc.right(j) = struct('op',jacobian(v,u),'val',v(b));
    end
    A = jacobian(r,u) & bc;
    A.scale = sqrt(sum( sum(u.^2,1)));
    delta = -(A\r);
    

    
    u = u + alpha*delta;
    u = jacvar(u);      % Reset the Jacobian of the function
    r = problemFun(u);
    

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
    %     u = chebfun(@(y) u(y)+delta(y),d);
%     subplot(2,1,1),plot(u);subplot(2,1,2),plot(delta,'r'),drawnow%pause
    counter = counter +1;
%     if nrmdu < 1e-1
%         alpha  = 1
%     end
    nrmduvec(counter) = nrmdu;
end
% disp(['Converged in ', num2str(counter), ' iterations']);
% toc;
end
