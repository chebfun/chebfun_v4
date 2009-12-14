%% pde15s_demos
% Some demos of pde15s (and pdesolve)

%% Advection
close all
[d,x] = domain(-1,1);
opts = pdeset('eps',1e-10,'abstol',1e-10,'reltol',1e-10,'plot',1);
u = exp(3*sin(pi*x));
plot(u); hold on
f = @(u,D) -D(u);
pde15s(f,0:.05:3,u,'periodic',opts);

%% Nonuniform Advection
clc, close all
[d,x] = domain(-1,1);
u = exp(3*sin(pi*x));
f = @(u,t,x,D) -(1+0.6*sin(pi*x)).*D(u);
pde15s(f,0:.05:3,u,'periodic');

%% Advection-diffusion
close all
[d,x] = domain(-1,1);
u = (1-x.^2).*exp(-30*(x+.5).^2);
f = @(u,t,x,D) -D(u)+.002*D(u,2);
pde15s(f,0:.05:3,u,'dirichlet');

%% Advection-diffusion2
close all
E = 1e-1;
[d x] = domain(-3*pi/4,pi);
u = sin(2*x);
f = @(u,t,x,D) E*D(u,2)+D(u);
lbc = struct( 'op', 'neumann', 'val', 0);
rbc = struct( 'op', 'dirichlet', 'val', 0);
bc = struct( 'left', lbc, 'right', rbc);
opts = pdeset('HoldPlot','on');
tt = linspace(0,5,21);
uu = pde15s(f,tt,u,bc,opts);
figure, surf(uu,tt)

%% Advection-diffusion3 (Time depended rhs bc)
close all
E = 1e-1;
[d x] = domain(-3*pi/4,pi);
u = sin(2*x);
f = @(u,t,x,D) E*D(u,2)+D(u);
lbc = struct( 'op', 'neumann', 'val',0);
rbc = struct( 'op', 'dirichlet', 'val', @(t) .1*sin(t));
bc = struct( 'left', lbc, 'right', rbc);
opts = pdeset('holdPlot','on');
tt = linspace(0,3,101);
uu = pde15s(f,tt,u,bc,opts);
figure, surf(uu,tt)

%% Advection-diffusion4 (nonlinear bcs)
close all, 
E = 1e-1;
[d x] = domain(-3*pi/4,pi);
u = sin(2*x);
f = @(u,t,x,D) E*D(u,2)+D(u);
lbc = @(u,t,x,D) D(u) + u - (1+2*sin(10*t));
rbc = @(u,t,x,D) (1+u.^2).*sin(pi*u)-(1-exp(-t)).*cos(10*t);
bc = struct( 'left', lbc, 'right', rbc);
tt = linspace(0,3,101);
uu = pde15s(f,tt,u,bc);
figure, surf(uu,tt)

%% Allen-Cahn
close all
[d,x] = domain(-1,1);
u = (1-x.^2).^2.*(1+sin(12*x))/2;
f = @(u,D) u.*(1-u) + 5e-4*D(u,2);
pde15s(f,0:0.1:5,u,'neumann');

%% Allen-Cahn 
close all
[d,x] = domain(-1,1);
u = .53*x-.47*sin(1.5*pi*x);
f = @(u,D) u.*(1-u.^2) + 5e-4*D(u,2);
bc.left = struct('op','dirichlet','val',-1);
bc.right = struct('op','dirichlet','val',1);
pde15s(f,0:0.1:5,u,bc);

%% Burgers
close all
[d,x] = domain(-1,1);
u = (1-x.^2).*exp(-30*(x+.5).^2);
f = @(u,D) -D(u.^2)+.01*D(u,2);
pde15s(f,0:.05:6,u,'dirichlet');

%% KS
close all
[d,x] = domain(-1,1);
I = eye(d); D = diff(d);
u = 1 + 0.5*exp(-40*x.^2);
bc.left = struct('op',{I,D},'val',{1,2});
bc.right = struct('op',{I,D},'val',{1,2});
f = @(u,D) u.*D(u)-D(u,2)-0.006*D(u,4);
u = pde15s(f,0:.01:.5,u,bc);

% %% Cahn-Hilliard - not working!
% close all
% E = 1e-1;
% [d,x] = domain(-1,1); 
% u = cos(pi*x)-exp(-6*pi*x.^2);
% plot(u)
% opts = pdeset('eps',1e-6,'abstol',1e-10,'reltol',1e-10,'plot',1);
% lbc = struct( 'op', {'dirichlet','neumann'}, 'val', {-1,0});
% rbc = struct( 'op', {'dirichlet','neumann'}, 'val', {-1,0});
% f = @(t,x,u,D) -D(u,4) + D(u.^3,2)-D(u,2);
% tt = linspace(0,.0005,101);
% uu = pde15s(f,tt,u,{lbc rbc},opts);
% surf(uu,tt)

