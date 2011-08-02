function pass = paramODE
% Test solving a parameter dependent ODE. 
% Nick Hale, August 2011

% Natural setup
N = chebop(@(x,u,a) x.*u + .001*diff(u,2) + a);
N.lbc = @(u,a) [u + a + 1, diff(u)];
N.rbc = @(u,a) u - 1;
u = N\0;

% Forced setup using a system
N = chebop(@(x,u,a) [x.*u + .001*diff(u,2) + a, diff(a)]);
N.lbc = @(u,a) [u + a + 1, diff(u)];
N.rbc = @(u,a) u - 1;
v = N\0;

pass = norm(u-v) < 1e-10;

% subplot(2,1,1)
% plot(u);
% subplot(2,1,2)
% plot(v)
% norm(u-v)
