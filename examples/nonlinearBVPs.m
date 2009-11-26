% The chebfun/chebop system offers users a straightforward way to solve
% nonlinear boundary value problems (BVPs) using automatic differentiation
% (AD) is described in the chebfun guide, chapter 10.
%
% Below we show two examples of how to solve nonlinear BVPs. The first
% problem is a second order problem, while the second one is a coupled
% second order system.
%
% Asgeir Birkisson, 2009

%% First problem
% Below, we show how to solve the problem
%
%   0.03u'' + u' + sin(u) = 0
%   u(0) = 0                            BVP (1)
%   u(1) = 1/2

% Set up domain and create an instance of the nonlinear operator object
[d,x,N] = domain(0,1);

% Assign the properties of the operator
N.op =  @(u) 0.03*diff(u,2) + diff(u,1) + sin(u);
N.lbc = @(u) u;
N.rbc = @(u) u-1/2;

% Solve the problem
u1 = N\0;
figure; plot(u1)
title('The solution of the BVP (1)')

% If we would instead have wanted to solve
%
%   0.03u'' + u' + sin(u) = x
%   u(0) = 0                            BVP (2)
%   u(1) = 1/2
%
% we can do that simply by executing \ with another argument on the RHS of
% the operator
u2 = N\x;
figure; plot(u2)
title('The solution of the BVP (2)')

%% Second problem
% Below, we show how to solve the problem
%
% (u_1)'' - sin(u_2) = 0
% (u_2)'' + cos(u_1) = 0                BVP(3)
% u_1(-1) = 1,      (u_2)''(-1) = 0
% (u_1)''(1) = 0,   u_2(1) = 0

% By using cells of anonymous functions, we can solve the problem as shown
% in the following lines:

[d,x,N] = domain(-1,1);
N.op = @(u) [ diff(u(:,1),2) - sin(u(:,2)), diff(u(:,2),2) + cos(u(:,1)) ];
N.lbc = {@(u) u(:,1)-1, @(u) diff(u(:,2))};
N.rbc =  {@(u) u(:,2), @(u) diff(u(:,1))};
N.guess = [0*x,0*x];
[u nrmduvec] = N\0;
figure;plot(u), title('The solution of the BVP (3)')
legend('u_1','u_2')