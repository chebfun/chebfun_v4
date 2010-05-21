%% pde15s_demos
% Some demos of pde15s

%% Advection
close all, clc, clear
[d,x] = domain(-1,1);
opts = pdeset('eps',1e-6,'abstol',1e-6,'reltol',1e-6,'plot',1,'HoldPlot',1,'PlotStyle','.-r','Jacobian','none');
u = exp(3*sin(pi*x));
f = @(u,D) -D(u);
[tt uu] = pde15s(f,0:.05:2,u,'periodic',opts);
waterfall(uu,tt,'simple')

%% Nonuniform Advection
clc, close all, clc, clear
[d,x] = domain(-1,1);
u = exp(sqrt(5)*sin(pi*x))
f = @(u,t,x,D) -(1+0.6*sin(pi*x)).*D(u);
opts = pdeset('plot',1,'HoldPlot',0,'PlotStyle','.-b');
[tt uu] = pde15s(f,0:.05:3,u,'periodic',opts);
waterfall(uu,tt,'simple')

%% Advection-diffusion
close all, clc, clear
[d,x] = domain(-1,1);
u = (1-x.^2).*exp(-30*(x+.5).^2);
f = @(u,t,x,D) D(u)+.002*D(u,2);
[tt uu] = pde15s(f,0:.05:2,u,'dirichlet');
waterfall(uu,tt,'simple')

%% Advection-diffusion2
close all, clc, clear
E = 1e-1;
[d x] = domain(-3*pi/4,pi);
u = sin(2*x);
f = @(u,t,x,D) E*D(u,2)+D(u);
lbc = struct( 'op', 'neumann', 'val', 0);
rbc = struct( 'op', 'dirichlet', 'val', 0);
bc = struct( 'left', lbc, 'right', rbc);
opts = pdeset('HoldPlot','off');
tt = linspace(0,2,51);
uu = pde15s(f,tt,u,bc,opts);
waterfall(uu,tt,'simple')


%% Advection-diffusion3 (Time depended rhs bc)
clc, close all, clc, clear
E = 1e-1;
[d x] = domain(-3*pi/4,pi);
u = sin(2*x);
f = @(u,t,x,D) E*D(u,2)+D(u);
lbc = struct( 'op', 'neumann', 'val',0);
rbc = struct( 'op', 'dirichlet', 'val', @(t) .1*sin(t));
bc = struct( 'left', lbc, 'right', rbc);
opts = pdeset('holdPlot','on');
tt = linspace(0,3,51);
uu = pde15s(f,tt,u,bc,opts);
waterfall(uu,tt,'simple')

%% Advection-diffusion4 (nonlinear bcs)
close all, clc, clear, 
E = 1e-1;
[d x] = domain(-3*pi/4,pi);
u = sin(2*x);
f = @(u,t,x,D) E*D(u,2)+D(u);
lbc = @(u,t,x,D) D(u) + u - (1+2*sin(10*t));
rbc = @(u,t,x,D) (1+u.^2).*sin(pi*u)-(1-exp(-t)).*cos(10*t);
bc = struct( 'left', lbc, 'right', rbc);
tt = linspace(0,3,101);
opts = pdeset('BDF','on','Plot','off');
uu = pde15s(f,tt,u,bc,opts);
waterfall(uu,tt,'simple')

%% Allen-Cahn
close all, clc, clear
[d,x] = domain(-1,1);
u = (1-x.^2).^2.*(1+sin(12*x))/2;
f = @(u,D) u.*(1-u.^2) + 5e-4*D(u,2);
[tt uu] = pde15s(f,0:0.1:5,u,'neumann');
waterfall(uu,tt,'simple')

%% Allen-Cahn 
close all, clc, clear
[d,x] = domain(-1,1);
u = .53*x-.47*sin(1.5*pi*x);
f = @(u,D) u.*(1-u.^2) + 5e-4*D(u,2);
bc.left = -1; bc.right = 1;
[tt uu] = pde15s(f,0:0.1:5,u,bc);
waterfall(uu,tt,'simple')
xlabel('x'); ylabel('t'), zlabel('u')
set(gca,'view',[-135.5000   50.0000])

%% Burgers
close all, clc, clear
[d,x] = domain(-1,1);
u = (1-x.^2).*exp(-30*(x+.5).^2);
f = @(u,D) -D(u.^2)+.01*D(u,2);
opts = pdeset('Eps',1e-6);
[tt uu] = pde15s(f,0:.1:4,u,'dirichlet',opts);
waterfall(uu,tt,'simple')

%% KS
close all, clc, clear
[d,x] = domain(-1,1);
tt = 0:.01:2;
I = eye(d); D = diff(d);
u = 1 + 0.5*exp(-40*x.^2);
bc.left = struct('op',{I,D},'val',{1,2});
bc.right = struct('op',{I,D},'val',{1,2});
f = @(u,D) u.*D(u)-D(u,2)-0.006*D(u,4);
opts = pdeset('Ylim',[-30 30],'plot',1);
[tt uu] = pde15s(f,tt,u,bc,opts,64);
waterfall(uu,tt,'simple')

%% Integro-differential Equation
close all, clc, clear
[d,x] = domain(-1,1);
u = (1-x.^2).*exp(-30*(x+.5).^2);
f = @(u,t,x,diff,sum,cumsum) .02*diff(u,2)+cumsum(u)*sum(u);
[tt uu] = pde15s(f,0:.1:4,u,'dirichlet');
waterfall(uu,tt,'simple')


%% Cahn-Hilliard - not working!
% close all, clc, clear
% E = 1e-1;
% [d,x] = domain(-1,1); 
% u = cos(pi*x)-exp(-6*pi*x.^2)
% plot(u)
% opts = pdeset('eps',1e-6);
% lbc = struct( 'op', {'dirichlet','neumann'}, 'val', {-1,0});
% rbc = struct( 'op', {'dirichlet','neumann'}, 'val', {-1,0});
% f = @(u,D) E*D(u,4) + D(u.^3-u,2);
% tt = linspace(0,.05,101);
% uu = pde15s(f,tt,u,{lbc rbc},opts,64);
% surf(uu,tt)

