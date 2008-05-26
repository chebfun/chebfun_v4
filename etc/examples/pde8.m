% pde8.m - solve u_xx = exp(u) via two cumsums & Picard iteration
%          TAD & LNT   20.1.07
% Not working properly

  u = chebfun(@(x) 0*x,[-1 1]);           % initial guess
  expu = exp(u);
  linear = chebfun(@(x) (x+1)/2,[-1 1]);  % linear correction function
  error = inf;
  step = 0;
  while error > 1e-9                     % tighter doesn't work
    step = step + 1;
    uii = cumsum(cumsum(expu));
    u = uii - uii(1)*linear;
    expu = exp(u);
    error = norm(diff(u,2)-expu);
    plot(u), grid on
    title(sprintf('step = %i, length(u) = %i, error = %.2e'...
       ,step,length(u),error),'fontsize',16)
    pause(.1)
  end

