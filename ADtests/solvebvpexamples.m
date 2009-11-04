%% Solving the ODE with the new method
% Below is shown how we can solve the BVP eps*u'' + u'+sin(u) = 0,
% u(0) = 0, u(1) = 1/2 using Newton iteration and the Jacobian
% calculations now available.

[d,x] = domain(0,1);
D = diff(d,1); D2 = diff(d,2);
tic;
nrmduvec = [];
nrmdu = Inf; u = x/2;
eps = 0.03;
counter = 0;
while nrmdu > 1e-10
    u = jacvar(u);    
    r = eps*D2*u + D*u + sin(u);
    A = eps*D2 + D + jacobian(sin(u),u) & 'dirichlet';
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

%% Using solveTAD to take care of all the iteration steps

f = @(u) 0.03*diff(u,2) + diff(u,1) + sin(u);
g.left = @(u) u;
g.right = @(u) u-1/2;
[u nrmduvec] = solvebvp(f,g,domain(0,1));
% figure;plot(u);title('Solution');
figure;subplot(1,2,1),plot(u),title('u(x) vs. x');
box on, grid on, xlabel('x'), ylabel('u(x)'), ylim([0 1.2]), set(gca,'Ytick',[0:0.2:1.2])
subplot(1,2,2),semilogy(nrmduvec,'-*');title('Norm of update vs. iteration no.');
box on, grid on, xlabel('Iteration no.'), ylabel('Norm of update');
set(gca,'XTick',[1:4])

%% Fourth order problem
f = @(u) 0.01*diff(u,4) + 10.*diff(u,2) + 100*sin(u);
g.left = @(u) u-1;
g.right = { @(u) u, @(u) diff(u), @(u) diff(u,2) };
[u nrmduvec] = solveTAD(f,g,domain(0,1));
figure;subplot(1,2,1),plot(u),title('u(x) vs. x');
box on, grid on, xlabel('x'), ylabel('u(x)'), %set(gca,'Ytick',[0:0.2:1.2])
subplot(1,2,2),semilogy(nrmduvec,'-*');title('Norm of update vs. iteration no.');
box on, grid on, xlabel('Iteration no.'), ylabel('Norm of update');
xlim([0 20]),set(gca,'XTick',[0:4:20])

%% System
f = @(u) [ diff(u(:,1)) - sin(u(:,2)), diff(u(:,2)) + cos(u(:,1)) ];
g.left = @(u) u(:,1)-1;
g.right = @(u) u(:,2);

[d,x] = domain(-1,1);
[u nrmduvec] = solvebvp(f,g,[0*x,0*x],1e-6 );
figure;plot(u)

%% 
f = @(u) [ diff(u(:,1),2) - sin(u(:,2)), diff(u(:,2),2) + cos(u(:,1)) ];
g.left = {@(u) u(:,1)-1, @(u) diff(u(:,2))};
g.right = {@(u) u(:,2), @(u) diff(u(:,1))};
[d,x] = domain(-1,1);
[u nrmduvec] = solvebvp(f,g,[0*x,0*x]);
figure;subplot(1,2,1),plot(u(:,1)),hold on, plot(u(:,2),'-.r'),hold off
title('u_1(x) and u_2(x) vs. x'); legend('u_1','u_2')
box on, grid on, xlabel('x'), ylabel('u_1(x) and u_2(x)')
subplot(1,2,2),semilogy(nrmduvec,'-*');title('Norm of update vs. iteration no.');
box on, grid on, xlabel('Iteration no.'), ylabel('Norm of update');

