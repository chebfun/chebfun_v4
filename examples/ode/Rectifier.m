%% HALF-WAVE RECTIFIER
% Toby Driscoll, May 18, 2011

%%
% (Chebfun example ode/Rectifier.m)

%%
% The initial-value problem 
% 
%   v' + ep*v = ep*(exp(alpha(sin(t)-v)) - 1), v(0)=0
%
% models a half-wave rectifier that converts AC current into DC. With
% small values of ep and large values of alpha, it is very stiff.

%%
% We start off with a mild form of the problem.
chebfunpref('factory');
ep = 1e-3;  alpha = 12;
N = chebop(0,30);
N.op = @(t,v) diff(v) + ep*v - ep*( exp(alpha*(sin(t)-v)) - 1 );
N.lbc =0;    % initial condition
v = N\0

%%
% As you can see above, the solution v(t) requires a rather large degree
% polynomial to represent it. The system is characterized by rapid jumps
% between slowly varying plateaus, and the jumps require high resolution.
LW = 'linewidth'; lw = 2; 
plot(v,LW,lw)
xlabel('t'), ylabel('v(t)'), 
title(['alpha = ',num2str(alpha),', length(v) = ',int2str(length(v))])

%%
% If we steepen the jumps by making the problem more stiff, we are well
% advised to "continue from" the previous solution, by using it as the
% initial guess to nonlinear iterations. This is done by setting the .init
% field of N.
alpha = 20;
N.op = @(t,v) diff(v) + ep*v - ep*( exp(alpha*(sin(t)-v)) - 1 );
N.init = v;
v = N\0;
plot(v,LW,lw)
xlabel('t'), ylabel('v(t)'), 
title(['alpha = ',num2str(alpha),', length(v) = ',int2str(length(v))])

%%
% Let's turn up the stiffness one more time. The representation length will
% close in on 1025, which is the default maximum size.
alpha = 40;
N.op = @(t,v) diff(v) + ep*v - ep*( exp(alpha*(sin(t)-v)) - 1 );
N.init = v;
v = N\0;
plot(v,LW,lw)
xlabel('t'), ylabel('v(t)'), 
title(['alpha = ',num2str(alpha),', length(v) = ',int2str(length(v))])

%%
% Currently Chebfun is not really a competitive way to solve most
% initial-value problems, unless perhaps you demand very high accuracy. But
% it does facilitate answering questions such as, "What is the maximum
% voltage, and when is it achieved?"
format long
[vmax,tmax] = max(v) 

%% Acknowledgment
% The author acknowledges Zhenyu He at the University of Delaware, who was
% the first to try Chebfun on this problem.
