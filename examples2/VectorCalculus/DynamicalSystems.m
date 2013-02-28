%% Classification of dynamical systems
% Georges Klein, 4th of March 2013

%%
% (Chebfun2 example VectorCalculus/DynamicalSystems.m)

%%
% A linear dynamical system in $\mathbf{R}^2$ for the trajectory $x(t)$ can 
% be written as  
% $$ x'(t) = A x(t), \qquad x(0) = x_0,$$ 
% where $A$ is a $2\times 2$ matrix. If $\lambda_1$ and $\lambda_2$ are the
% eigenvalues of $A$ (assuming that $A$ is diagonalizable) with eigenvectors 
% $v_1$ and $v_2$, then the solution is given by
% $$ x(t) = \alpha_1 e^{\lambda_1 t} v_1 + \alpha_2 e^{\lambda_2 t} v_2.$$
% The solution thus depends heavily on the eigenvalues of A; see also [1].
%
% If both eigenvalues have positive real part, then the solution must
% diverge. The following code uses Chebfun2 first to plot the phase plane 
% with quiver, then to plot two individual trafectories. 
% The initial value of each solution is marked with a dot.

LW = 'linewidth'; FS = 'fontsize'; MS = 'markersize';

A = [2 0; 0 2];
g = chebfun2v(@(x,y) x, @(x,y) y);
G = A*g;
[~, y] = ode45(G,[0 2],[.1,.1]);    % chebfun2v overload of ode45
quiver(G,'b',LW,2), hold on, axis equal
plot(y,'r',LW,2), plot(y(0),'r.',MS,20)
[~, y] = ode45(G,[0 2],[0,-0.1]);
plot(y,'g',LW,2), plot(y(0),'g.',MS,20), hold off

%%
% Since at least one of the eigenvalues has positive real part, the phase 
% portrait has an unstable fixed point (source, repellor) at the origin.
% If both eigenvalues have nonpositive real part, then the solution can not 
% grow infinitely large in absolute value. The origin is here a stable fixed 
% point (sink, attractor).

A = [-2 0; 0 -2];
G = A*g;
[~, y] = ode45(G,[0 3],[-1,-1]);
quiver(G,'b',LW,2), hold on, axis equal
plot(y,'r',LW,2), plot(y(0),'r.',MS,20)
[~, y] = ode45(G,[0 3],[1,0]);
plot(y,'g',LW,2), plot(y(0),'g.',MS,20), hold off

%%
% When both eigenvalues are purely imaginary, the phase portrait has a
% center:

A = [0 1;-2 0]; eig(A)
G = A*g;
[~, y] = ode45(G,[0 5],[.2,0]);
quiver(G,'b',LW,2), hold on, axis equal
plot(y,'r',LW,2), plot(y(0),'r.',MS,20)
[~, y] = ode45(G,[0 5],[.5,0]);
plot(y,'g',LW,2), plot(y(0),'g.',MS,20), hold off

%%
% Of course, not every matrix has only real or imaginary eigenvalues. Assume 
% the entries of $A$ are real, the remaining cases of complex eigenvalues are 
% most conveniently described by the trace and the determinant of the matrix A, 
% and all cases can be summarized in the following picture:

s1 = .3*scribble('saddles');
s2 = .3*scribble('unstable');
s3 = .3*scribble('stable');
s4 = .3*scribble('spirals');
rt = chebfun('2*sqrt(x)',[0 1],'splitting','on');
plot([-1 1],[0 0],LW,1.6), hold on
plot([0 0],[-2 2],LW,1.6), 
plot([rt -rt],'b',LW,1.6),
labels = [s1 - .5+1i; s1 - .5-1i; s2 + .4+1.8i; s3 + .4-1.8i; ...
    s2 + .6+.8i; s4 + .6+.6i; s3 + .6-.6i; s4 + .6-.8i];
plot(labels,LW,1)
title('Stability of dynamical systems',FS,16)
xlabel('det(A)',FS,14), ylabel('tr(A)',FS,14), hold off

%%
% Here are the last cases, an unstable spiral:

A = [2 -9;2 1]; eig(A)
G = A*g;
[~, y] = ode45(G,[0 2.1],[.1,0]);
quiver(G,'b',LW,2), hold on
plot(y,'r',LW,2), plot(y(0),'r.',MS,20)
[~, y] = ode45(G,[0 1.3],[.3,0]);
plot(y,'g',LW,2), plot(y(0),'g.',MS,20), hold off

%%
% a stable spiral:

A = [.2 -1;1 .2]; eig(A)
G = A*g;
[~, y] = ode45(G,[0 13],[.1,0]);
quiver(G,'b',LW,2), hold on
plot(y,'r',LW,2), plot(y(0),'r.',MS,20)
[~, y] = ode45(G,[0 13],[-.1,0]);
plot(y,'g',LW,2) ,plot(y(0),'g.',MS,20), hold off

%%
% and a saddle:

A = [-2 0; 0 2]; eig(A)
G = A*g;
[~, y] = ode45(G,[0 2],[1,.1]);
quiver(G,'b',LW,2), hold on, axis equal
plot(y,'r',LW,2), plot(y(0),'r.',MS,20)
[~, y] = ode45(G,[0 2],[-1,-.1]);
plot(y,'g',LW,2), plot(y(0),'g.',MS,20), hold off

%%
% Let us now look at nonlinear dynamical systems, beginning with a Hopf
% bifurcation system, which contains a stable circular limit cycle. 
% In the first case, every solution tends a the circle. The system is
% $$ \frac{\mathrm{d} x}{\mathrm{d} t} = bx - y - (x^2+y^2)x  $$
% $$ \frac{\mathrm{d} y}{\mathrm{d} t} = x + by - (x^2+y^2)y. $$
% With $b>0$, this Hopf bifurcation is supercritical, meanig that the 
% trajectories move toward the limit cycle rather than away.

b = .3;
G = chebfun2v(@(x,y) b*x-y-(x.^2+y.^2).*x ,@(x,y) x+b*y-(x.^2+y.^2).*y);
[~, y] = ode45(G,[0 10],[.1,.1]);
quiver(G,'b',LW,2), hold on, axis equal 
plot(y,'r',LW,2), plot(y(0),'r.',MS,20)
[~, y] = ode45(G,[0 10],[1,1]);
plot(y,'g',LW,2), plot(y(0),'g.',MS,20)
s = chebfun('s',[0 2*pi]);
plot(sqrt(0.3)*exp(1i*s),'k',LW,2), hold off

%%
% The following lightly modified Hopf bifurcation is subcritical, it has an 
% unstable closed orbit limit cycle when $b<0$,
% $$ \frac{\mathrm{d} x}{\mathrm{d} t} = bx - y + (x^2+y^2)x   $$
% $$ \frac{\mathrm{d} y}{\mathrm{d} t} = x + by + (x^2+y^2)y.  $$
% If the initial value is on
% that cycle, then the solution remains thereon; a small perturbation
% causes the solution to moce away.

b = -1.2;
G = chebfun2v(@(x,y) b*x-y+(x.^2+y.^2).*x, @(x,y) x+b*y+(x.^2+y.^2).*y);
[~, y] = ode45(G,[0 10],[0,-1.08]);
quiver(G,'b',LW,2), hold on, axis equal 
plot(y,'r',LW,2), plot(y(0),'r.',MS,20)
[~, y] = ode45(G,[0 1.5],[0,-1.1]);
plot(y,'g',LW,2), plot(y(0),'g.',MS,20)
plot(sqrt(1.2)*exp(1i*s),'k'), hold off


%%
% As a last continuous dynamical system, we show a Van der Pol oscillator,
% which has a stable cycle with a more interesting shape; see also [3]. 
% The oscillator evolves in time according to
% $$ \frac{\mathrm{d}^2 y}{\mathrm{d}^2 t} - \frac{\mathrm{d} y}{\mathrm{d} t} \mu (a-y^2) + y = 0. $$

a = 0.1; mu = 10;
F = chebfun2v(@(x,y) y, @(x,y) -x+mu*y.*(a-x.^2));
[~, y] = ode45(F,[0 10],[1,-1]);
quiver(F,'b',LW,2), hold on, axis equal
plot(y,'r',LW,2), plot(y(0),'r.',MS,20)
[~, y] = ode45(F,[0 10],[0.1,0.1]);
plot(y,'g',LW,2), plot(y(0),'g.',MS,20), hold off

%%
% So far we have been looking at continuous dynamical systems. There is
% also a discrete analogue, sometimes called maps. 
% One out of a huge catalogue is the Tinkerbell map; see [3].

a = .9; b = -.6013; c =2; d = 0.50;
G = chebfun2v(@(x,y) x.^2-y.^2+a*x+b*y,@(x,y) 2*x.*y+c*x+d*y,2*[-1 1 -1 1]);
X = [-.72; -.64];
T = X;
for k = 1:10000
    X = G(X(1),X(2));
    T = [T, X];
end
plot(1,1,'k.','Markersize',5000), hold on
plot(T(1,:),T(2,:),'g.',MS,1) 
title('Tinkerbell map')


%% 
% References:
%%
% [1] R. Abraham and J. E. Marsden, \textit{Foundations of Mechanics},
% Benjamin–Cummings, 1978.
%% 
% [2] http://en.wikipedia.org/wiki/Van_der_Pol_oscillator
%%
% [3] http://en.wikipedia.org/wiki/Tinkerbell_map