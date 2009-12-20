%%  Solving the Blasius Equation with Chebfuns
% Andre Weideman, 15 Nov--6 Dec, 2009

%% Introduction
% Consider the Blasius function, defined by
% $$  u^{\prime \prime \prime} + \frac12 u u^{\prime \prime} = 0, \qquad [0,\infty) $$
% subject to 
% $$ u(0) = u^{\prime}(0) = 0, \qquad \lim_{t \to \infty} u^{\prime}(t) = 1 $$
% We'll try to reproduce some of the results in the paper by John P. Boyd, 
% ``The Blasius Function in the Complex Plane'', Experimental Mathematics, 
% Vol. 8 (1999) pp. 382--394.

%% Solution via Nonlinear Chebops
% We discretize the boundary-value problem on  a truncated domain
% $[0,L]$, as follows
L = 15;
[d,t,N] = domain(0,L);
N.op  = @(u) diff(u,3)+1/2*u.*diff(u,2);
N.lbc = {@(u) u, @(u) diff(u,1)};
N.rbc =  @(u) diff(u,1)-1;
N.guess = [t];
u = N\0;
figure(1); plot(u,'LineWidth',2); grid on;
title(['Solution of the Blasius equation, on [0,' num2str(L) ']',])
%% Curvature computation
% The curvature at the origin can be computed by
d2u = diff(u,2); 
curv = d2u(0)
%%
% Boyd has computed the same quantity, which he claims correct to 16
% decimals
curv_Boyd = 0.33205733621519630 
%%
% The difference is
err = curv-curv_Boyd

%%
% It seems that the value computed here agrees to about ten places or so 
% with that of Boyd.  Increasing the value of $L$ does not seem to yield further
% digits.   Presumably the discrepancy is due to ill-conditioning of the
% third derivative operator and the computation of the second derivative. 
%%
% In the above computation we used $u = t$ as initial guess.   The original
% initial guess was $u = 0$, but Nick T and I found that for largish values
% of $L$ (around $15$ or so) there appeared to be 
% convergence to a different solution, non-monotonic with negative curvature at the
% origin.  (Follow up?)
%%  Singularities
% The singularity structure of the Blasius equation is considered in detail 
% in Boyd's paper.  Here we do a single experiment using the Chebyshev-Pade
% method.
[p,q,r] = chebpade(u,16,16);
xx = linspace(-8,8,100);
yy = xx; 
[XX,YY] = meshgrid(xx,yy);
z = XX+1i*YY;
Q = q(z);
R = r(z);
figure(2);
contour(xx,yy,log10(abs(R)),50);  colorbar vert;
xlabel('Re z','FontSize',16); ylabel('Im z','FontSize',16); 


%%
% The plot shows contour values of $\log_{10}|r(z)|$ where $r$ is the
% $[16,16]$ rational function computed by chebpade.  Red curves correspond
% to large values and blue to small.   
% The position of the singularity at $x = -5.690038$ (as given in Boyd's paper) seems to be captured 
% reasonably accurately.   The singularities on the rays $\theta = \pm
% \pi/3$ are captured less well.   At each point it actually appears as two
% singularities (or one that has split into two).   This is indicative
% of the complicated singularity structure mentioned by Boyd in his paper.
% Relatedly, it should be said that the choice $[16,16]$ required a bit of
% experimentation---other nearby choices did not work as well. 
