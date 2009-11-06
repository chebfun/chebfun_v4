function pass = ad
% Testing AD functionality 
% Asgeir

%% Initialize domain, x and the chebfun 1
[d,x] = domain(1,3);
one = chebfun(1,d);
%% Plus, minus, scalar times, power
u = 2 + 10*x - x.^3;
J = diff(u,x);
pass(1) = norm( diff(u) - J*one ) < 1e-11;

%% Product rule, quotient rule, sqrt
v = 3 + sqrt(x);
w = u.*v + u./v;
J = diff(w,x);
pass(2) = norm( diff(w) - J*one ) < 1e-11;

%% elementary functions
y = sin(exp(x)) + log(2+cos(x));
J = diff(y,x);
pass(3) = norm( diff(y) - J*one ) < 1e-11;

%% diff and cumsum
u = sin(exp(x));
D = diff(d);  C = cumsum(d);
z = u.*(D*u) - C*(u.^2);
J = diff(z,u);
JJ = diag(D*u) + diag(u)*D - 2*C*diag(u);
pass(4) = norm( J(20) - JJ(20) ) < 1e-11;

%% system
J = diff( [D*u-v,u+D*v],[u v] );
r = J*[sin(x),cos(x)];
pass(5) = norm(r,'fro') < 1e-13;

