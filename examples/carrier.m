% carrier  Newton iteration for nonlinear ODE BVP due to Carrier
%          eps u" + 2(1-x^2)u + u^2 = 1  on [-1,1], Dirichlet BCs
%          See Bender & Orszag 1978, Sec. 9.7
clear
[d,x] = domain(-1,1);
D2 = diff(d,2); F = diag(2*(1-x.^2));
if ~exist('u'), u = 2*(x.^2-1).*(1-2./(1+20*x.^2)); end
eps = 0.01; nrmdu = Inf;
while nrmdu > 1e-10
  plot(u), drawnow, shg
  r = eps*D2*u + F*u + u.^2 - 1;
  A = eps*D2 + F + diag(2*u) & 'dirichlet';
  A.scale = norm(u); delta = -(A\r);
  u = u+delta;  nrmdu = norm(delta)
end
