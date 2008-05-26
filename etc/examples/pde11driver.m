% pde11driver - play with TAD's new and improved pde11

  x = chebfun(@(x) x);
  q = 0*x;
  p = 0*x;
  f = exp(x);

% Plot the G function:
  figure(1)
  G = pde10(p,q);
  for xj = -0.8:0.2:0.8, plot(G(xj)), hold on, end
  drawnow

% Solve the BVP:
  figure(2)
  tic
  u = pde11(p,q,f);
  toc
  plot(u)
  error = norm(diff(u,2)+p.*diff(u)+q.*u-f)


