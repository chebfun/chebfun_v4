%  pde4.m -- Solve Bratu-like equation using chebfuns
%
%    u_t = u_xx + exp(u),  u(+-1)=0
%
%  Uses BD2/Euler in time and spectral solutions called adaptively by
%  chebfun construction.

%  TAD & LNT,  19/01/07

function pde4()

x = chebfun(@(x) x,[-1,1]);
u = 0*x;                  % initial condition
dt = .008;                % time step
tmax = 3.8;
% One BE step to get starting value.
U = {u chebfun( @(x) bvp(x,u+dt*exp(u),dt) ) };
t = dt;
while t < tmax
  rhs = (4/3)*U{2} - (1/3)*U{1} + (2/3)*dt*exp(u);  
  u = chebfun(@(x) bvp(x,rhs,(2/3)*dt));
  t = t+dt;
  U = { U{2} u };
  plot(u), ylim([-0.5 11]), grid on
  title(sprintf('t = %0.4f;  length(u) = %i',t,length(u)))
  drawnow
end

end

%%%%%%%%
% Solve the BVP associated with the implicit time stepping.
function u = bvp(x,f,k)

N = length(x)-1;
D = cheb(N); D2 = D^2; D2 = D2(2:N,2:N);
A = eye(N-1)-k*D2;
u = A\f(x(2:N));
u = [0; u; 0];

end

