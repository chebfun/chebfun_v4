%% Delta functions and ODEs
% Mohsin Javed, 3rd July 2012

%%
% (Chebfun example ode/DeltaODEs.m)
% [Tags: ]

%% ODEs with Dirac-Delta functions on the RHS
% Chebfun can now solve ODEs with delta functions on the right-hand side.
% To solve the problem, $$ Lu = \delta(x-x_0), $$ where $L$ is a linear
% differential operator, we convert this distributional problem to a
% classical problem with appropriate boundary conditions. Specifically, if
% $L$ is an $n^{th}$ order linear operator, we enforce continuity of $u$
% and its first $n-2$ derivatives and a jump of appropriate magnitude in
% the $(n-1)^{st}$ derivative of $u$ at the location of the delta function
% $x_0$ [2]. Once this is done, Chebfun considers the problem as a BVP with
% interior boundary conditions. Thanks to Nick Hale, Chebfun has
% capabilities to solve such problems. (See for example [3]).

%%
% Let's start with a very simple example. We know that the derivative of
% the Heaviside function is the delta function. We can now solve $u'(x) =
% \delta(x)$ in Chebfun to get the same result:
x = chebfun('x');
L = chebop(@(u) diff(u)); L.lbc = 0;
u = L\dirac(x);
plot(u), ylim([-.2 1.2])

%%
% We can solve the same differential equation for a slightly interesting
% right-hand side.
u = L\(4*cos(4*pi*x)+ dirac( x+.75)-2*dirac(x)+dirac(x-.75));
plot(u)

%%
% We now move on to second order operators. The so called hat function can
% be written as a solution of a BVB with delta functions on the RHS.
L = chebop( @(h) diff(h,2) ); L.lbc = 0; L.rbc = 0;
hat = L\(dirac(x-.5)-2*dirac(x)+dirac(x+.5));
plot(hat)

%%
% The solution is pretty accurate:
norm(hat-max(0,1/2*(1-abs(2*x))),inf)

%% Impulse Response of an Electrical Network
% Here is a practical example from electrical circuit theory. A four
% terminal RLC-network is modelled by a second order differential equation
% with constant coefficients. We now find the impulse response of such a
% network:
d = domain(-.01,1);
L = chebop(@(u) diff(u,2)+20*diff(u)+10000*u, d);
L.lbc = @(u) [diff(u),u];
x = chebfun('x', d);
u = L\dirac(x); plot(x,u)

%% ODEs with generalized solutions
% A linear homogeneous differential equation with analytic coefficients
% does not have generalized solutions other than the classical solutions.
% However for an equation with singular coefficients, we sometimes can get
% new generalized solutions [2]. For example, let us consider the confluent
% hypergeometric equation $$ xy''+(2-x)y'-y=0. $$ It is known that $y(x) =
% \delta(x)$ is a solution of this equation [2]. We can easily verify this
% in Chebfun as well:

x = chebfun('x'); y = dirac(x);
r = x.*diff(y,2)+(2-x).*diff(y)-y; 
r.imps

%%
% We can also check that
norm(r,inf)

%%
% $\delta(x)$ is also a solution of the Bessel's equation
% $$x^2y''+xy'+(x^2-1)y=0.$$ Again, we can verify this easily.
r = x.^2.*diff(y,2)+x.*diff(y)+(x.^2-1).*y;
r.imps

%%
% Finally we verify that $\delta(x)-\delta'(x)$ solves
% $$ xy''+(3-x)y'-y=0. $$
y = dirac(x)-dirac(x,1);
r = x.*diff(y,2)+(3-x).*diff(y)-y;
r.imps
norm(r,inf)

%% References
% [1] Stakgold, I. Green's functions and boundary value problems. Pure and
% Applied Mathematics (New York). John Wiley & Sons Inc., New York, second
% edition, 1998. A Wiley-Interscience Publication.
%
% [2] Kanwal, R. P. Generalized Functions: Theory and Applications, third
% edition, 2004, Birkhauser.
%
% [3] http://www2.maths.ox.ac.uk/chebfun/examples/ode/html/JumpConditions.shtml