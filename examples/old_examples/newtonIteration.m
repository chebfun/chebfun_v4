%% Solving BVPs with Newton iteration
% Below is shown how we can solve the BVP eps*u'' + u'+sin(u) = 0,
% u(0) = 0, u(1) = 1/2 using Newton iteration directly, creating the
% Jacobian explicitly.

[d,x] = domain(0,1);
D = diff(d,1); D2 = diff(d,2);
tic;
nrmduvec = [];
nrmdu = Inf; u = x/2; % Initial guess that fulfills BCs
eps = 0.03;
counter = 0;
while nrmdu > 1e-10
    r = eps*D2*u + D*u + sin(u);
    A = eps*D2 + D + diag(cos(u)) & 'dirichlet'; % Linearized operator
    A.scale = norm(u);
    delta = -(A\r);
    u = u + delta;
    nrmdu = norm(delta);
    counter = counter +1;
    nrmduvec(counter) = nrmdu;
end
disp(['Converged in ', num2str(counter), ' iterations']);
figure;plot(u);title('Solution');
figure;semilogy(nrmduvec);title('Norm of update');
toc;

%% Using chebops to take care of all the iteration steps
% Below we solve the same problem as above, but using nonlinear chebops.
[d,x,N] = domain(0,1);
N.op = @(u) 0.03*diff(u,2) + diff(u,1) + sin(u);
N.lbc = 0;
N.rbc = 1/2;

cheboppref('plotting','on');
cheboppref('display','iter');
[u nrmduvec] = N\0

figure;subplot(1,2,1),plot(u),title('u(x) vs. x');
box on, grid on, xlabel('x'), ylabel('u(x)'), ylim([0 1.2]), set(gca,'Ytick',[0:0.2:1.2])
subplot(1,2,2),semilogy(nrmduvec,'-*');title('Norm of update vs. iteration no.');
box on, grid on, xlabel('Iteration no.'), ylabel('Norm of update');
set(gca,'XTick',[1:4])