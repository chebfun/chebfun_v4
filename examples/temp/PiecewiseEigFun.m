%% EIGENFUNCTIONS OF A PIECEWISE OPERATOR
% Nick Hale, November 2010

%%
% (Chebfun Example ode/PiecewiseEigenFun.m)

%%
% On the domain [-10 10], 
% we seek the eigenfunctions of the Schrödinger operator
% with poential V(x) = 200*(abs(x)>5).  Here's a plot of
% the potential:
d = [-10,10];
x = chebfun('x',d);
V = 400*( (x < -6) + (x > -.5) + (x < .5) + (x > 6) );
LW = 'LineWidth'; lw = 2;
plot(V,LW,lw), ylim([0 1000])

%%
% We compute the first six eigenvalues and eigenfunctions:
H = chebop(d);
H.op = @(u) -2*diff(u,2) + V.*u;
H.bc = 'dirichlet';
[psi D] = eigs(H,6)
plot(psi,LW,lw)

%%
% Physicists like to plot things differently, shifting
% the eigenfunctions by their corresponding eigenvalues:
plot(psi+repmat(chebfun(1,d),1,length(D))*D,LW,lw)

%%
% The above is correct. Some eigenfunctions are just hidden behind each
% other. See:
T = psi+repmat(chebfun(1,d),1,length(D))*D;
C = get(0,'DefaultAxesColorOrder');
figure
for k = 1:6
    subplot(3,2,k)
    plot(T(:,k),'color',C(k,:),LW,lw);
end
