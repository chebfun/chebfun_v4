function carrier
% carrier: Newton iteration for nonlinear ODE BVP due to Carrier
%          eps u" + 2(1-x^2)u + u^2 = 1  on [-1,1], Dirichlet BCs
%          See Bender & Orszag 1978, Sec. 9.7


% Defining the equation
[d,x] = domain(-1,1);
eps = 0.01; 
D2 = diff(d,2); F = diag(2*(1-x.^2));
ode = @(u) eps*D2*u + F*u + u.^2 - 1;
jac = @(u) eps*D2 + F + diag(2*u);

% Initial condition (satisfying boundary conditions)
u = 2*(x.^2-1).*(1-2./(1+20*x.^2));

% Solve via Newton Iteration
nrmdu = Inf;
while nrmdu > 1e-10
  plot(u), drawnow, shg
  r = ode(u);
  A = jac(u) & 'dirichlet';
  A.scale = norm(u); 
  delta = -(A\r);
  u = u+delta;  
  nrmdu = norm(delta)
end
plot(u); hold on

%%

% This can now be solved using nonlinops
prefstate = cheboppref('display','iter');

[d,x,N] = domain(-1,1);
eps = 0.01;
N.op = @(u) eps*diff(u,2) + 2*(1-x.^2).*u + u.^2 - 1;
N.bc = 'dirichlet';
N.guess = 2*(x.^2-1).*(1-2./(1+20*x.^2));
u = N\0;

plot(u,'--r'); hold off

cheboppref(prefstate)