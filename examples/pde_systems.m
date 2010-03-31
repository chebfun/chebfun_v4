%% A selection of PDE system examples (borrowed from Pedro).

%%

clc, clear, close all

[d,x] = domain(-1,1); 
u = [ chebfun(1,d)  chebfun(1,d) ];

f = @(u,t,x,D) [ -u(:,1) + (x + 1).*u(:,2) + 0.1*D(u(:,1),2) , ...
                  u(:,1) - (x + 1).*u(:,2) + 0.2*D(u(:,2),2) ];
                   
D = diff(d); Z = zeros(d);
bc.left = {[D Z], [Z D]};
bc.right = bc.left;
        
uu = pde15s(f,0:.05:3,u,bc,32);


%%

clc, clear, close all

[d,x] = domain(-1,1);  
u = [ 1-erf(10*(x+0.7)) , 1 + erf(10*(x-0.7)) , chebfun(0,d) ];
f = @(u,t,x,D)  [ 0.1*D(u(:,1),2) - 100*u(:,1).*u(:,2) , ...
                  0.2*D(u(:,2),2) - 100*u(:,1).*u(:,2) , ...
                 .001*D(u(:,3),2) + 2*100*u(:,1).*u(:,2) ];
bc = 'neumann';     

uu = pde15s(f,0:.1:3,u,bc);

%%

clc, clear, close all

% Crazy nonlinear boundary conditions

[d,x] = domain(-1,1); 
u = [ chebfun(1,d)  chebfun(1,d) ];

f = @(u,t,x,D) [ -u(:,1) + (x + 1).*u(:,2) + 0.1*D(u(:,1),2) , ...
                  u(:,1) - (x + 1).*u(:,2) + 0.2*D(u(:,2),2) ];

bc.left = {@(u,t,x,D) D(u(:,1))+t*sin(u(:,1))./u(:,2), @(u,t,x,D) D(u(:,2))};
bc.right = {@(u,t,x,D) D(u(:,1)), @(u,t,x,D) D(u(:,2)).*u(:,2)+sin(5*pi*t)};
        
uu = pde15s(f,0:.05:3,u,bc);

%% Maxwell's Equations

clc, clear, close all
[d,x] = domain(-1,1); 
u = exp(-20*x.^2) .* sin(14*x);  u = [u -u];
D = diff(d); I = eye(d); Z = zeros(d);
f = @(u,D) [D(u(:,2)) ; D(u(:,1))];
bc.left = [I Z];
bc.right = [I Z];

opt = pdeset('eps',1e-6);
uu = pde15s(f,0:.05:3,u,bc,opt);