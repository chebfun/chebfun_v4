% Cash & Wright test problem 33, a nonlinear 4th order system
% TAD

ep = 0.02;
[d,x] = domain(0,1);
D = diff(d);  Z = zeros(d);  I = eye(d);

% BCs on the Newton corrections
bc.left = struct('op',{[I Z],[Z I],[Z D]},'val',{0,0,0});
bc.right = struct('op',{[I Z],[Z I],[Z D]},'val',{0,0,0});

f = @(u) [ ep*D^2*u(:,1) - u(:,1).*(D*u(:,2)) + u(:,2).*(D*u(:,1)), ...
   ep*D^4*u(:,2) + u(:,2).*(D^3*u(:,2)) + u(:,1).*(D*u(:,1)) ];

J = @(u) [ep*D^2 - diag(D*u(:,2)) + diag(u(:,2))*D, ...
  -diag(u(:,1))*D + diag(D*u(:,1)) ;
  diag(u(:,1))*D + diag(D*u(:,1)), ...
  ep*D^4 + diag(u(:,2))*D^3 + diag(D^3*u(:,2)) ]  &  bc;

y = [2*x-1, zeros(d,1)];
dy = Inf;

while norm(dy) > 1e-9
  r = f(y);
  A = J(y);
  A.scale = norm(y);
  dy = -(A\r);
  y = y+dy;
  norm(dy)
end
