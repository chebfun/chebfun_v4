%% Complex Singularities Of The Three Body Problem
% Marcus Webb, 23rd August 2011

%%
% (Chebfun example ode/ThreeBodyProblem.m)

%% 
% This example is motivated by a correspondence with Divakar Viswanath,
% University of Michigan.

%% Introduction
% The three body problem is a system of ODEs modelling three particles of
% prescribed masses m1,m2,m3 under mutual gravitation in two or three
% dimensions. We will consider the two dimensional case, so that we can use
% complex arithmetic to solve it in Chebfun.
%% 
% u'' = m2*(v-u)*abs(v-u)-3 + m3*(w-u)*abs(w-u)-3,
%% 
% v'' = m1*(u-v)*abs(u-v)-3 + m3*(w-v)*abs(w-v)-3, 
%% 
% w'' = m1*(u-w)*abs(u-w)-3 + m2*(v-w)*abs(v-w)-3. 
%%
% Subject to initial conditions.

%% Figure Of Eight Solution
% In 2000 Chenciner and Montgomery [3] presented a paper showing the existence 
% of "A remarkable periodic solution of the three-body problem in the case 
% of equal masses". The particles travel around a figure of eight shape
% (shown below).

%% 
% Here we use modified versions of the initial conditions given in the
% paper.

dom = domain([0,4*pi]);
a = 6.32591398/(2*pi); % scaling factor to give period 2pi
opts = odeset('abstol',1e-13,'reltol',1e-13);
fun = @(t,u) a*[u(4);u(5);u(6);...
    ((u(2)-u(1))./abs(u(2)-u(1)).^3+(u(3)-u(1))./abs(u(3)-u(1)).^3);...
    ((u(1)-u(2))./abs(u(1)-u(2)).^3+(u(3)-u(2))./abs(u(3)-u(2)).^3);...
    ((u(1)-u(3))./abs(u(1)-u(3)).^3+(u(2)-u(3))./abs(u(2)-u(3)).^3)];
u = ode113(fun, dom,[0.540508553669932 + 0.345263318559681i,...
    0.540508532338285 - 0.345263317862853i,...
    -1.081017086008497 - 0.000000000697245i,...
    -1.097122372968180 - 0.233604741427372i,...
    1.097122377013713 - 0.233604786311327i, ...
    -0.000000004046108 + 0.467209527738458i],...
    opts);

plot(u(:,1),'linewidth',2);
title('Figure Of Eight Solution To Three Body Problem');
axis equal; grid on; hold on; 
plot(u(0,1:3), 'ok', 'MarkerFaceColor','k','MarkerSize',7);
quiver(real([u(0,1),u(0,2),u(0,3)]),imag([u(0,1),u(0,2),u(0,3)]),...
    real([u(0,4),u(0,5),u(0,6)]),imag([u(0,4),u(0,5),u(0,6)]),...
    0.4, 'k','linewidth',2);
hold off;

%% Computing The Complex Singularities
% Let us consider the chebfun representing the third particle, whose
% initial value appears on the left in the above plot. This is a complex 
% valued chebfun with domain [0, 4pi], (2 periods). 

v = u(:,3)

%%
% We can compute a rational interpolant for v using the robust rational
% interpolation and least squares algorithm described in [2]. Then we can
% consider the interpolant as an analytic continuation of the underlying
% function and analyse its singularities.

%%
% The above output shows that the degree of v is 313. In general, a good
% choice for the degrees of the numerator and denominator for a rational
% interpolant of a polynomial with robustness is about half the degree, so
% we shall use a [157,156] rational interpolant. We don't expect 
% there to be 156 singularities - ratinterp will remove extra poles of
% small residue. For interpolation nodes we use the 314 Chebyshev points of 
% type 2 along [0,4pi] and a tolerance of 1e-12 for the robustness.

[p,q,rh,mu,nu,poles] = ratinterp(v,157,156, 314, 'type2', 1e-12);

mu
nu

%%
% The robustness of the algorithm reduces the degree of the rational
% interpolant to [mu,nu] = [154,6] in this case,
% but we still have a good error estimate on the real interval:

max(abs(rh(0:0.1:4*pi) - v(0:0.1:4*pi)))


%% Analysis Of Singularities
% The poles calculated above are,

poles

%%
% A straightforward analysis considering the symmetries of the system 
% (communicated to me by Viswanath) shows that if the solution has any 
% complex singularities, the real part may only take the values 
% pi/3*[1,2,4,5] (mod 2pi).

real(poles)*3/pi


%%
% We have found poles with real parts approximately
% pi/3*[2,4,5,7,8,10]. We appear to have missed one singularity at each 
% end, indicated by the periodicity of the solution.

%%
% Let us plot the poles with blue dots and the zeros as black circles:

plot([0,4*pi]+eps*i,'-r'); hold on
plot(roots(q,'all'),'o','markersize',4,'color','b','markerfacecolor','b');
plot(roots(p,'complex'), 'ok', 'markersize',5);

axis equal; grid on;

chebellipseplot(v);

title('Poles, Zeros Of Rational Interpolant and Bernstein Ellipse For v');
hold off;

%%
% chebellipseplot(v) plots the Bernstein ellipse associated with v.
% This ellipse is an estimate, based on the decay of the Chebyshev
% coefficients of v, of the largest ellipse with foci -1 and 1 in which
% the underlying function approximated by v is analytic. The poles appear
% around the edge of this ellipse.

%%
% Interestingly, at time t=real(t_0) where v has a singularity at complex
% time, t_0, the particles form a triangle. In the following plot, the 
% particle under consideration, number 3, is coloured black and the other
% two particles are blue.

plot(v,'linewidth',2);
title('Configuration Of Particles At Singularity');
axis equal; grid on; hold on;

plot(u(pi/3,1:2), 'ok', 'MarkerFaceColor','b','MarkerSize',7);
plot(u(pi/3,3), 'ok', 'MarkerFaceColor','k','MarkerSize',7);
quiver(real([u(pi/3,1),u(pi/3,2),u(pi/3,3)]),...
    imag([u(pi/3,1),u(pi/3,2),u(pi/3,3)]),...
    real([u(pi/3,4),u(pi/3,5),u(pi/3,6)]),...
    imag([u(pi/3,4),u(pi/3,5),u(pi/3,6)]),...
    0.4, 'k','linewidth',2);

hold off;

%% Without Robustness
% Now let us do exactly the same with robustness switched off (tol=0):

[p,q,rh,mu,nu,poles,res] = ratinterp(v,157,156, 314, 'type2', 0);

plot([0,4*pi]+eps*i,'-r'); hold on
plot(roots(q,'complex'),'o','markersize',4,'color','b','markerfacecolor','b');
plot(roots(p,'complex'), 'ok', 'markersize',5);

axis equal; grid on;

chebellipseplot(v); 
title('Without Robustness');

%%
% This is a demonstration of the phenomenon of spurious poles or 
% "Froissart doublets" - each pole is paired (almost) with a zero in the
% numerator. The robust algorithm in [2] removes such poles with an implementation
% based on the singular value decomposition.

%% References
% [1] A. Chenciner and R. Montgomery. A remarkable periodic solution of the
% three-body problem in the case of equal masses. Annals of Mathematics-
% Second Series, 152(3):881–902, 2000.
%
% [2] P. Gonnet, R. Pachón, and L.N. Trefethen. Robust rational 
% interpolation and least-squares. Electronic Transactions on 
% Numerical Analysis, 38:146–167, 2011.
%
% [3] Wikipedia article:
% 'http://en.wikipedia.org/wiki/Three_body_problem'