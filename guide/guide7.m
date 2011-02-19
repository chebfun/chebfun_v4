%% CHEBFUN GUIDE 7: SOLVING LINEAR DIFFERENTIAL EQUATIONS WITH CHEBOPS
% Tobin A. Driscoll, November 2009, revised February 2011

%% 7.1  Overview of differential equations in Chebfun
% Chebfun has powerful capabilities for solving ordinary
% differential equations as well as partial differential equations
% involving one space and one time variable.
% The present chapter is devoted to chebops, the fundamental Chebfun tools
% for solving differential (or integral)
% equations.  In particular we focus here on the
% linear case.  We shall see that one can solve a linear two-point boundary
% value problem to high accuracy by a single backslash command.  Nonlinear
% extensions are described in Chapter 10.

%%
% For linear or nonlinear problems posed on an interval that also have a
% time variable, several approaches have been investigated.  One of these
% is implemented in the Chebfun code pde15s, described in Chapter 11.

%% 7.2  About linear chebops
% A chebop represents a differential or integral operator that acts on
% chebfuns. This chapter focusses on the linear case, though from
% a user's point of view linear and nonlinear problems are quite similar.
% One thing that makes linear operators special is that EIGS and EXPM
% can be applied to them, as we shall describe.

%%
% Like chebfuns, chebops are built on the premise of appoximation by
% piecewise Chebyshev polynomial interpolation; in the context of differential
% equations such techniques are called spectral collocation methods. (See
% the references at the end of this chapter for further reading.) Also as
% with chebfuns, the sizes of function discretizations are chosen
% automatically to achieve the maximum possible accuracy available from
% double precision arithmetic.

%%
% The linear part of the chebop package was first conceived at Oxford
% University by Folkmar Bornemann, Toby Driscoll, and Nick Trefethen
% [Driscoll, Bornemann & Trefethen 2008].  The implementation is due
% to Driscoll, Hale, and Birkisson.  Much of the functionality of linear
% chebops is actually implemented in a class called linop, but users
% generally do not need to deal with linops directly.

%% 7.3 Chebop syntax
% A chebop has a domain, an operator, and sometimes boundary conditions.
% For example, here is the chebop corresponding to the second-derivative
% operator on [-1,1]:
L = chebop(-1,1);
L.op = @(u) diff(u,2);

%%
% This operator can now be applied to chebfuns defined on [-1,1].
% For example, taking two derivatives of sin(3x) multiplies its
% amplitude by 9:
u = chebfun('sin(3*x)');
norm(L(u),inf)

%%
% Both the notations L*u and L(u) are allowed, with the same meaning.
% (Mathematicians
% generally prefer L*u if L is linear and L(u) if it is nonlinear.)
min(L*u)

%%
% A chebop can also have left and/or right boundary conditions.  For a
% simple Dirichlet boundary condition it's enough to specify a number:
L.lbc = 0;
L.rbc = 1;

%%
% More complicated boundary conditions can be specified with anonymous functions.
% For example, the following sequence imposes the conditions u=0 at the
% left bounday and u'=1 at the right:
L.lbc = @(u) u;
L.rbc = @(u) diff(u)-1;

%%
% We can see a summary of L by typing the name without a semicolon:
L

%%
% Boundary conditions are needed for solving differential equations, but
% they have no effect at all when a chebop is simply applied to a chebfun.
% Thus, despite the boundary conditions just specified,
% L*u gives the same answer as before:
norm(L*u,inf)

%%
% Here is an example of an integral operator, the operator that maps
% u defined on [0,1] to its indefinite integral:
L = chebop(0,1);
L.op = @(u) cumsum(u);

%%
% For example, the indefinite integral of x is x^2/2:
x = chebfun('x',[0,1]);
hold off, plot(L*x)

%%
% Chebops can be specified in various ways, including all in a
% single line.  For example we could write
L = chebop(@(u) diff(u)+diff(u,2),[-1,1])

%%
% Or we could include boundary conditions:
L = chebop(@(u) diff(u)+diff(u,2),[-1,1],@(u) 0,@(u) diff(u))

%% 7.4 Solving differential and integral equations
% In Matlab, if A is a square matrix and b is a vector, then the command
% x=A\b solves a linear system of equations.  Similarly in Chebfun, if L is
% a differential operator and f is a Chebfun, then u=L\f solves a
% differential equation.  More generally L might be an integral or
% integro-differential operator.

%%
% For example, suppose we want to solve the differential
% equation u"+x^3*u = 1 on [-5,5] with Dirichlet boundary 
% conditions.  Here is a solution:
L = chebop(-5,5);
L.op = @(x,u) diff(u,2) + x.^3.*u;
L.lbc = 0; L.rbc = 0;
u = L\1;
plot(u)

%%
% Let's change the right-hand boundary condition to u'=0 and see
% how this changes the solution:
L.rbc = @(u) diff(u);
u = L\1;
hold on, plot(u,'r')

%%
% An equivalent to backslash is the SOLVEBVP command:
v = solvebvp(L,1);
norm(u-v)

%%
% Periodic boundary conditions can be imposed with the
% special boundary condition string L.bc='periodic', which will 
% find a periodic solution, provided that the right-side function is
% also periodic.
L.bc = 'periodic';
u = L\1;
hold off, plot(u)

%%
% A command like L.bc=100 imposes the corresponding Dirichlet condition
% at both ends of the domain:
L.bc = 100;
plot(L\1)

%%
% Boundary conditions can also be specified in a single line with
% the "&" symbol, like this specification of the operator on [-1,1] mapping
% u = u"+10000u:
L = chebop(@(u) diff(u,2)+10000*u,[-1,1]) & 0

%%
% Thus it is possible to set up and solve a differential equation
% in a single line of Chebfun:
plot((chebop(@(u) diff(u,2)+10000*u,[-1,1]) & 0)\chebfun('exp(x)'))

%% 7.5 Eigenvalue problems -- EIGS
% In Matlab, EIG finds all the eigenvalues of a matrix whereas EIGS finds
% some of them.  A differential or integral operator normally has 
% infinitely many eigenvalues, so one could not expect an overload of EIG
% for chebops.  EIGS, however, has been overloaded.  Just like Matlab's
% EIGS, it finds 6 eigenvalues by default, together with eigenfunctions
% if requested.  Here's an example involving sine waves.
L = chebop(@(u) diff(u,2),[0,pi]);
L.bc = 0;
[V,D] = eigs(L);
diag(D)
clf, plot(V(:,1:4))

%%
% By default, eigs tries to find the six eigenvalues that are "most readily
% converged to", which approximately means the smoothest ones.
% You can change the number sought and tell eigs where to
% look for them. Note, however, that you can easily confuse eigs if you ask
% for the wrong eigenvalues--such as finding the largest eigenvalues of a
% differential operator.

%%
% Here are eigenvalues of the Mathieu equation, and the resulting elliptic
% sines and cosines. Note the imposition of periodic boundary conditions.
q = 10;
A = chebop(-pi,pi);
A.op = @(x,u) diff(u,2) - 2*q*cos(2*x).*u;
A.bc = 'periodic';
[V,D] = eigs(A,30,'LR');  % values with largest real part
subplot(1,2,1), plot(V(:,1:2:5)), title('elliptic cosines')
subplot(1,2,2), plot(V(:,2:2:6)), title('elliptic sines')

%%
% Eigs can also solve generalized eigenproblems. Here is an example of
% modes from the Orr-Sommerfeld equation of hydrodynamic linear stability
% analysis at Reynolds number very close to the onset of
% eigenvalue instability [Schmid & Henningson 2001]. This is a
% fourth-order generalized eigenvalue
% problem, requiring two conditions at each boundary.
Re = 5772;           
B = chebop(-1,1);
B.op = @(x,u) diff(u,2) - u;
A = chebop(-1,1);
A.op = @(x,u) (1/Re)*(diff(u,4)-2*diff(u,2)+u) -...
       1i*(2*u+(1-x.^2).*(diff(u,2)-u));
A.lbc = @(u) [u diff(u)];
A.rbc = @(u) [u diff(u)];
lam = eigs(A,B,40,'LR');
clf, plot(lam,'r.'), grid on, axis equal
max(real(lam))

%% 7.6 Exponential of a linear operator -- EXPM
% Another means of creating a chebop is intimately tied to the solution of
% time-dependent PDEs: the exponential of a linear operator (i.e., the
% semigroup generated by the operator). For example, we might advance the
% solution of the heat equation as follows.
A = chebop(@(u) diff(u,2),[-1,1]);  
f = chebfun('exp(-20*(x+0.3).^2)');
clf, plot(f,'r'), hold on, c = [0.8 0 0];
for t = [0.01 0.1 0.5]
  E = expm(t*A & 'dirichlet');
  plot(E*f,'color',c),  c = 0.5*c;
end

%%
% Here is a more fanciful analogous computation with a complex initial
% function obtained from the "scribble" command introduced in Chapter 5.
% (As it happens "expm" does not map non-smooth data with the usual Chebfun
% accuracy, so warning messages are generated.)

f = scribble('BLUR');
d = domain(-1,1); D = diff(d,2); clf
k = 0;
for t = [0 .0001 .001 .01]
k = k+1; subplot(2,2,k)
  if t==0, Lf = f; else L = expm(t*D & 'neumann'); Lf = L*f; end
  plot(Lf,'linewidth',3,'color',[.6 0 1])
  xlim(1.05*[-1 1]), axis equal
  text(.3,.7,sprintf('t = %6.4f',t),'fontsize',12), axis off
end

%% 7.7 Algorithms and accuracy

%% 
% Whether one applies \ to solve a linear equation, eigs to find
% eigenmodes, or * with an operator exponential, the underlying process is
% similar. The chebfun construction of the solution requests function
% values at finite numbers of points n = 9, 17, 33,... until the desired
% function or eigenfunctions are deemed to have been fully resolved after
% inspection of their Chebyshev coefficients.

%%
% For each n, the spectral collocation matrix corresponding to the operator
% is realized. Boundary conditions are used to modify the matrix (and the
% right-hand side for \) so that they become implicit in the linear algebra
% of the n-dimensional system, and the corresponding finite-dimensional
% solution is found using the built-in \, eig, or expm functions.

%%
% The discretization length of the chebfun solution is thus chosen
% automatically according to the instrinsic resolution requirements.
% However, since the linear algebra problems used to produce solution
% values at finite dimension cannot in general be expected to have
% condition numbers close to 1, we cannot expect the resulting solutions to
% be accurate to full machine precision. Typically one loses just a few
% digits for second-order differential problems, but six or more digits for
% fourth-order problems.

%% 7.8 Nonlinear equations by Newton iteration
% As mentioned at the beginning of this chapter, nonlinear differential equations are
% discussed in Chapter 10.  As an indication of some of the possibilities,
% however, we now illustrate how a sequence of linear problems may be
% useful in solving nonlinear problems. For example, the nonlinear BVP
% 
% .001u'' - u^3 = 0,  u(-1)=1, u(1)=-1
% 
% can be solved by Newton iteration as follows.
[d,x] = domain(-1,1); 
D2 = .001*diff(d,2); 
u = -x;  nrmdu = Inf;
while nrmdu > 1e-10
  r = D2*u - u.^3;
  J = D2 - diag(3*u.^2) & 'dirichlet';
  J.scale = norm(u);
  delta = -(J\r);
  u = u+delta;  nrmdu = norm(delta)
end
clf, plot(u)

%%
% Note the beautifully fast convergence, as one expects with Newton's
% method. The chebop J is a Jacobian (=Frechet derivative) operator, which
% we have constructed explicitly by differentiating the nonlinear operator
% defining the ODE.  In Section 10.4 we shall see that this process can be
% automated by use of Chebfun's "nonlinear backslash" capability, which in
% turn utilizes a built-in chebfun Automatic Differentiation (AD) feature.
% In Section 10.2 we shall see that it is also possible to solve such
% problems with the chebfun overloads of the Matlab boundary-value problem
% solvers bvp4c and bvp5c.

%%
% The line "J.scale=norm(u)" in the code above tells the constructor for
% the \ solution that delta needs to be found accurately only relative to
% the size of u, not relative to its own size. As u approaches the correct
% value, the norm of delta gets small and therefore delta does not require
% much intrinsic resolution in order to make the proper correction to u.

%% 7.9 Systems of equations and block operators
% Chebops support some functionality for systems of equations. Here is an
% eigenvalue example:
[d,x] = domain(-1,1);
D = diff(d); I = eye(d); Z = zeros(d);
A = [ Z D; D Z ];
A.lbc = [I Z];
A.rbc = [I Z];

eigs(A,16)/pi

%%
% Note that boundary condition operators need to have the correct number of
% block columns. In the case above, the first variable in the system has
% Dirichlet conditions at both ends, while the second is unconstrained.

%%
% Here we exponentiate the same operator to see the time-evolution behavior
% of this system (Maxwell's equations).
f = exp(-20*x.^2) .* sin(14*x);  f = [f -f];
subplot(1,3,1), plot(f)
subplot(1,3,2), plot( expm(0.9*A & A.bc)*f ), ylim([-1 1])
subplot(1,3,3), plot( expm(1.8*A & A.bc)*f )

%% 7.10 References
%
% [Driscoll, Bornemann & Trefethen 2008] T. A. Driscoll, F. Bornemann, and
% L. N. Trefethen, "The chebop system for automatic solution of
% differential equations", BIT Numerical Mathematics 46 (2008),701-723.
%
% [Driscoll & Hale 2011] T. A. Driscoll and N. Hale, manuscript in preparation,
% 2011.
%
% [Fornberg 1996] B. Fornberg, A Practical Guide to Pseudospectral Methods,
% Cambridge University Press, 1996.
%
% [Schmid & Henningson 2001] P. J. Schmid and D. S. Henningson,
% Stability and Transition in Shear Flows, Springer, 2001.
%
% [Trefethen 2000] L. N. Trefethen, Spectral Methods in MATLAB, SIAM, 2000.
