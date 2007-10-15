% pde9.m -- Solve u_t = u_xx + f(t,u) by fully implicit backward Euler
%   TAD, 21 Jan 2007
% Not working.
function pde9()

f = @(t,u) exp(u);
dfdu = @(t,u) exp(u);

x = chebfun(@(x) x,[-1,1]);
u = 0*x;                  % initial condition
dt = .04;                 % time step
t = 0;  tmax = 4;
unew = u;                % initial guess for next step
shg
while (t < tmax) && (u(0) < 8)
  rhs = u;
  % Solve nonlinear BVP by Newton iteration on linear BVPs.
  du = Inf;  m = 0;  
  while (norm(du) > 1e-6) && (m < 6)
    du = chebfun( @(x) newtonstep(x,unew) );
    unew = unew+du;
    m = m+1;
  end
  if (abs(unew(0)-u(0)) < 0.25) && (m < 6)
    t = t+dt;
    u = unew;
    unew = rhs + 2*(u-rhs);   % extrapolate for next guess
    plot(u,'linewidth',2.5), ylim([-0.5 11]), grid on
    title(sprintf('t = %0.4f;  length(u) = %i;  %i Newton steps',t,length(u),m))
    drawnow
  else
    dt = dt/2;  dt = min(dt,tmax-dt);
    unew = u + 0.5*(unew-u);
  end
end  % while time stepping
 
  function v = newtonstep(x,u)
    N = length(x)-1;
    D = cheb(N); D2 = D^2;
    D2 = D2(2:N,2:N);  x = x(2:N);
    ux = u(x);
    residual = ux - dt*(D2*ux + f(t,ux)) - rhs(x);
    dfdux = dfdu(t,ux);
    J = eye(N-1) - dt*( D2 + diag(dfdux) );
    v = [0; -J\residual; 0];
  end  % newtonstep()

end  % pde9()

