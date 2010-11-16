function syssolve_ex
%% Demonstrating how to solve systems using different discretisations for each variable. 
%
% u  - v' = |x|
% v' + u  + lambda = sign(x)
% lamba'  = 0 
%
% u(-1) = -1 
% v(-1) = -6
% v(1)  = 0.

cc

[d x] = domain(-1,1);

D = diff(d);I = eye(d);Z = zeros(d);

A = [I -D Z ; D I I ; Z Z D];
A.lbc = {[I Z Z],-1};
A.lbc(2) = {[Z I Z],-6};
A.rbc = {[Z I Z],0};
% A.rbc(2) = {[D Z Z],-1};

x0 = x; x0(0) = 0;
% f = [abs(x) sign(x) 0];
% f = [ abs(x) sign(x) 0];
f = [x x 0];


u = A\f

plot(u)
legend('u','v','lambda')

err = A*u-f;
norm(err(:,1).vals,inf)

v = merge(u(:,2))
figure, chebpolyplot(v)

return

%% Second example

[d x] = domain(-1,1);
A = diff(d,2) + eye(d) & {'dirichlet',[3 0]};
f = abs(x)+abs(x-.5) + 2*sign(x);

u = A\f

plot(f,'b',u,'--r')

err = A*u-f;
norm(err.vals,inf)