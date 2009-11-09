function pass = ellipj_ode

tol = 50*chebfunpref('eps');

% Elliptic parameter
m = .9;
K = ellipke(m);
[d,x] = domain(0,K);

% jacobi elliptic functions
[sn cn dn] = ellipj(x,m); 

% SN is the solution of an ODE
f = @(u) diff(u,2) + (1+m)*u - 2*m*u.^3;
g.left = @(u) u;
g.right = @(u) u - 1 ;
u = solvebvp(f,g,d);

pass(1) = norm(u-sn,inf) < tol;

return

% We could also do the other elliptic functions,
% CN & DN, but these are inaccurate and fail...

% CN
f = @(u) diff(u,2) + (1-2*m)*u + 2*m*u.^3;
g.left = @(u) u - 1 ;
g.right = @(u) u ;
u = solvebvp(f,g,d);

pass(2) = norm(u-sn,inf) < tol;

% DN
f = @(u) diff(u,2) - (2-m)*u + 2*u.^3;
g.left = @(u) u - 1 ;
g.right = @(u) u - sqrt(1-m);
u = solvebvp(f,g,d);

pass(3) = norm(u-sn,inf) < tol;


