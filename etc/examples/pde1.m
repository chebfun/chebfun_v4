%  pde1.m -- Solve heat equation using chebfuns
%
%    u_t = u_xx,  u(+-1)=0
%
%  Using backward Euler in time and spectral solutions called adaptively by
%  chebfun construction.

%  TAD & LNT,  19/01/07

function pde1()

x = chebfun(@(x) x,[-1,1]);
u = cos(pi/2*x) + 0.5*cos(7*pi*x/2) + 0.2*sin(8*pi*x);    % initial condition
dt = .0005;                % time step
tmax = 0.1;
t = 0;
while t < tmax
  rhs = u;  
  u = chebfun(@(x) bvp(x,rhs,dt));
  t = t+dt;
  plot(u), ylim([-0.5 2]), grid on
  title(sprintf('t = %0.4f;  length(u) = %i',t,length(u)))
  drawnow
end

end

%%
% Solve the BVP associated with the implicit time stepping.
function u = bvp(x,f,k)

N = length(x)-1;
D = cheb(N); D2 = D^2; D2 = D2(2:N,2:N);
A = eye(N-1)-k*D2;
u = A\f(x(2:N));
u = [0; u; 0];

end