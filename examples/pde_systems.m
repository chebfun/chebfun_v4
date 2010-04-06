%% A selection of PDE system examples

%%

clc, clear, close all

[d,x] = domain(-1,1); 
u = [ chebfun(1,d)  chebfun(1,d) ];

f = @(u,v,t,x,D) [ -u + (x + 1).*v + 0.1*D(u,2) , ...
                    u - (x + 1).*v + 0.2*D(v,2) ];
                   
D = diff(d); Z = zeros(d);

% bc.left = {[D Z], [Z D]};  bc.right = bc.left;          % Old way
bc.left = @(u,v,D) [D(u), D(v)];  bc.right = bc.left;   % New way
        
uu = pde15s(f,0:.05:3,u,bc,32);


%%

clc, clear, close all

[d,x] = domain(-1,1);  
u = [ 1-erf(10*(x+0.7)) , 1 + erf(10*(x-0.7)) , chebfun(0,d) ];

f = @(u,v,w,D)      [ 0.1*D(u,2) - 100*u.*v , ...
                      0.2*D(v,2) - 100*u.*v , ...
                     .001*D(w,2) + 2*100*u.*v ];                  
bc = 'neumann';     

uu = pde15s(f,0:.1:3,u,bc);

%%

clc, clear, close all

% Crazy nonlinear boundary conditions

[d,x] = domain(-1,1); 
u = [ chebfun(1,d)  chebfun(1,d) ];

f = @(u,v,t,x,D) [ -u + (x + 1).*v + 0.1*D(u,2) , ...
                    u - (x + 1).*v + 0.2*D(v,2) ];

bc.left =  @(u,v,t,x,D) [D(u)+t*sin(u)./v,  D(v)];
bc.right = @(u,v,t,x,D) [D(u),              D(v).*v+sin(5*pi*t)];
        
uu = pde15s(f,0:.05:1,u,bc);

%%

clc, clear, close all

% Maxwell's Equations

[d,x] = domain(-1,1); 
u = exp(-20*x.^2) .* sin(14*x);  u = [u -u];
D = diff(d); I = eye(d); Z = zeros(d);
f = @(u,v,D) [D(v) ; D(u)];

% bc.left = [I Z]; bc.right = [I Z];                % Old way
bc.left = @(u,v,D) u; bc.right = @(u,v,D) v;        % New way

opt = pdeset('eps',1e-6, 'Ylim',pi/2*[-1 1]);
uu = pde15s(f,0:.05:2,u,bc,opt,64);