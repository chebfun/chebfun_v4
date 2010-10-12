%% TIME-DEPENDENT INTEGRO-DIFFERENTIAL EQUATION
% Nick Hale, October 2010

%%
% (Chebfun example pde/IntegroDiffT.m)

%%
% Here we demonstrate how to solve the time-dependent integro-differential
% equation using Chebfun's PDE15S command.
%
%    u_t = 0.02 u''(x) + int_{-1}^{1}u(xi)dxi * int_{-1}^{x}u(xi) 
%    u(-1) = u(1) = 0

%%
% Domain of computation
[d,x] = domain(-1,1);

%%
% Initial condition
u0 = (1-x.^2).*exp(-30*(x+.5).^2);

%%
% The right-hand side
f = @(u,t,x,diff,sum,cumsum) 0.02*diff(u,2)+cumsum(u)*sum(u);

%%
% The 4th, 5th, and 6th arguments define the differential, integral 
% (sum), and indefinite integral (cumsum) operators respectively. 
% See 'help pde15s' for more details.

%%
% Solve the system
[tt uu] = pde15s(f,0:.1:4,u0,'dirichlet');

%%
% Plot the result
FS = 'fontsize';
waterfall(uu,tt,'simple')
xlabel('x',FS,14)
ylabel('t',FS,14)
zlabel('z',FS,14)
