%% A selection of PDE system examples (borrowed from Pedro).

%%

clc, clear, close all

[d,x] = domain(-1,1); 
u = 1-erf(10*(x+0.7));

f = @(u,D) 0.1*D(u,2);
        
uu = pde15ss(f,0:.05:3,u,'neumann');

%%

clc, clear, close all

[d,x] = domain(-1,1); 
u = [ chebfun(ones(17,1),d)  chebfun(ones(17,1),d) ];

f = @(u,t,x,D) [ -u(:,1) + (x + 1).*u(:,2) + 0.1*D(u(:,1),2) , ...
                  u(:,1) - (x + 1).*u(:,2) + 0.2*D(u(:,2),2) ];
              
D = diff(d); Z = zeros(d);
bc.left = struct('op',{[D Z], [Z D]},'val',{0 0});
bc.right = bc.left
        
uu = pde15ss(f,0:.05:3,u,bc);


%%

clc, clear, close all

[d,x] = domain(-1,1); 
u = [ 1-erf(10*(x+0.7)) , 1 + erf(10*(x-0.7)) , chebfun(zeros(17,1),d) ];

f = @(u,t,x,D)  [ 0.1*D(u(:,1),2) - 100*u(:,1).*u(:,2) , ...
                  0.2*D(u(:,2),2) - 100*u(:,1).*u(:,2) , ...
                 .001*D(u(:,3),2) + 2*100*u(:,1).*u(:,2) ];
              
D = diff(d); Z = zeros(d); I = eye(d);
A = [D^2 2*I 2*I ; 2*I D^2 2*I ; 2*I 2*I D^2];
bc.left = struct('op',{[D Z Z], [Z D Z], [Z Z D]},'val',{0 0 0});
bc.right = bc.left;
        
uu = pde15ss(f,0:.05:3,u,bc);