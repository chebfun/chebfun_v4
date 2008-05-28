function u = cw33

% Cash & Wright test problem 33, a nonlinear 4th order system
% TAD

ep = 0.02;
[d,x] = domain(0,1);
D = diff(d);  Z = zeros(d);  I = eye(d);

% BCs on the Newton corrections
bc.left = struct('op',{[I Z],[Z I],[Z D]},'val',{0,0,0});
bc.right = struct('op',{[I Z],[Z I],[Z D]},'val',{0,0,0});

  function f = residual(u)
    y = u(:,1);  z = u(:,2);
    f      = ep*D^2*y - y.*(D*z) + z.*(D*y);
    f(:,2) = ep*D^4*z + z.*(D^3*z) + y.*(D*y);
  end

  function J = jacobian(u)
    y = u(:,1);  z = u(:,2);
    J11 = ep*D^2 - diag(D*z) + diag(z)*D;
    J12 = -diag(y)*D + diag(D*y);
    J21 = diag(y)*D + diag(D*y);
    J22 = ep*D^4 + diag(z)*D^3 + diag(D^3*z);
    J = [ J11 J12; J21 J22 ] & bc;
  end
  
f = @residual;  J = @jacobian;
u = [2*x-1, zeros(d,1)];
du = Inf;

while norm(du) > 1e-9
  r = f(u);
  A = J(u);
  A.scale = norm(u);
  du = -(A\r);
  u = u+du;
  norm(du)
end

end