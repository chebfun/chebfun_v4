%  pde2.m -- Solve convection-diffusion using chebfuns
%
%    u_t + u_x = nu*u_xx,  u(+-1)=0
%
%  Using backward Euler in time and spectral solutions called adaptively by
%  chebfun construction.

%  TAD & LNT,  19/01/07

function pde2()
  x = chebfun(@(x) x,[-1,1]);
  nu = 0.004;
  u = cos(pi/2*x);    % initial condition
  dt = .03;                % time step
  tmax = 30;
  t = 0;
  while t < tmax
    rhs = u; 
    dt = min(dt,tmax-t);
    u = chebfun(@(x) bvp(x,rhs,dt));
    t = t+dt;
    plot(u), ylim([-0.5 1.5]), grid on
    title(sprintf('t = %0.4f;  length(u) = %i',t,length(u)))
    drawnow
  end

  %%
  % Solve the BVP associated with the implicit time stepping.
  function u = bvp(x,f,k)

    N = length(x)-1;
    D = cheb(N); D2 = D^2;
    L = nu*D2 - D;
    A = eye(N-1) - k*L(2:N,2:N);
    u = A\f(x(2:N));
    u = [0; u; 0];
    
  end
  
end

