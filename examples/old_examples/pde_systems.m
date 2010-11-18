%% A selection of PDE system examples

%%

clc, clear, close all

[d,x] = domain(-1,1); 
u = [ chebfun(1,d)  chebfun(1,d) ];

f = @(u,v,t,x,diff) [ -u + (x + 1).*v + 0.1*diff(u,2) , ...
                    u - (x + 1).*v + 0.2*diff(v,2) ];
bc.left = @(u,v,D) [D(u), D(v)];  bc.right = bc.left;   % New way
% bc = 'neumann';    
opts = pdeset('Jacobian','auto','plot',1);
uu = pde15s(f,0:.05:2,u,bc,opts);

%% % Periodic boundary conditions

clc, clear, close all

[d,x] = domain(-1,1); 
u = [ chebfun(1,d)  chebfun(1,d) ];

f = @(u,v,t,x,diff) [ -u + (x + 1).*v + 0.1*diff(u,2) , ...
                    u - (sin(3*pi*x) + 1).*v + 0.2*diff(v,2) ];
bc = 'periodic';    
opts = pdeset('plot',1);
uu = pde15s(f,0:.05:2,u,bc,opts);


%% % Crazy nonlinear boundary conditions

clc, clear, close all

[d,x] = domain(-1,1); 
u = [ chebfun(1,d)  chebfun(1,d) ];

f = @(u,v,t,x,D) [ -u + (x + 1).*v + 0.1*D(u,2) , ...
                    u - (x + 1).*v + 0.2*D(v,2) ];

bc.left =  @(u,v,t,x,D) [D(u)+t*sin(u)./v,  D(v)];
bc.right = @(u,v,t,x,D) [D(u),              D(v).*v+sin(5*pi*t)*v.^2];

opts = pdeset('Jacobian','auto');
uu = pde15s(f,0:.05:1,u,bc,opts);


%% Reaction - diffusion system

clc, clear, close all

[d,x] = domain(-1,1);  
u = [ 1-erf(10*(x+0.7)) , 1 + erf(10*(x-0.7)) , chebfun(0,d) ];

f = @(u,v,w,D)      [ 0.1*D(u,2) - 100*u.*v , ...
                      0.2*D(v,2) - 100*u.*v , ...
                     .001*D(w,2) + 2*100*u.*v ];                  
bc = 'neumann';     
uu = pde15s(f,0:.1:2,u,bc);


%% % Maxwell's Equations
clc, clear, close all

[d,x] = domain(-1,1); 
u = exp(-20*x.^2) .* sin(14*x);  u = [u -u];
D = diff(d); I = eye(d); Z = zeros(d);
f = @(u,v,D) [D(v) , D(u)];

% bc.left = [I Z]; bc.right = [Z I];                % Old way
bc.left = @(u,v,D) u; bc.right = @(u,v,D) v;        % New way

opt = pdeset('eps',1e-6, 'Ylim',pi/2*[-1 1]);
uu = pde15s(f,0:.05:2,u,bc,opt,50);