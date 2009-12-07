%% CHEBFUN GUIDE 7: SOLVING LINEAR DIFFERENTIAL EQUATIONS WITH CHEBOPS
% Tobin A. Driscoll, November 2009

%% 7.1  Overview of differential equations and chebfun
% The chebfun system has powerful capabilities for solving
% ordinary differential equations as well as partial differential 
% equations involving one space and one time variable.  This is
% a rapidly developing area, and the methods we describe today will
% undoubtedly have evolved further a year from now.

%%
% The present chapter is devoted to chebops, the fundamental chebfun tools
% for solving differential equations.  In particular we focus here on the
% linear case.  We shall
% see that one can solve a linear two-point boundary value problem to high
% accuracy by a single backslash command.  Nonlinear extensions are
% described in Chapter 10.

%%
% For linear or nonlinear problems posed on an interval that also have a time variable,
% several approaches have been investigated.  One of these is implemented in the
% chebfun code pde15s.

%% 7.2  About linear chebops
% A chebop represents a differential or integral operator that acts
% on chebfuns. This chapter is devoted to the linear case, and we shall mention
% the qualifier "linear" sometimes but not always.
% Chebops are designed to understand and obey many appropriate
% commands defined by Matlab for matrices, including solving system of equations,
% and in the linear case also including eigenvalue problems.

%%
% Like chebfuns, chebops are built on the premise of appoximation by
% Chebyshev polynomial interpolation; in the context of differential
% equations such techniques are called spectral collocation methods. (See 
% the references at the end of this chapter for further reading.) Also
% as with chebfuns, the sizes of function discretizations are chosen
% automatically to achieve the maximum possible accuracy available from
% double precision arithmetic. 

%%
% The linear part of the chebop package was first conceived at Oxford University by Folkmar
% Bornemann, Toby Driscoll, and Nick Trefethen [Driscoll, Bornemann & Trefethen
% 2008].  The implementation has been by Toby Driscoll.  At the time of this
% writing, a good deal of the functionality of linear chebops is actually implemented
% in a class called linops.

%% 7.3 chebop syntax
% Many linear chebops are created out of three basic building blocks, eye, diff,
% and cumsum, which represent the identity, differentiation, and indefinite
% integration operators on a specified domain.
[d,x] = domain(0,1);  
I = eye(d);
D = diff(d);
Q = cumsum(d);

%%
% Each chebop stores instructions for how to instantiate itself at any
% finite dimension:
I(4)
full(I(7))

%%
% Each chebop also stores instructions for an "infinite-dimensional" 
% representation, as expressed by an anonymous function: 
I(Inf)
D(Inf)

%%
% In practice, though, there is little need to query the objects for these
% representations, as they are used automatically. For instance, the
% operator * is used to apply the chebop's infinite-dimensional form to a
% chebfun.
f = sin(exp(2*x)).^2;
subplot(1,2,1), plot(f)
subplot(1,2,2), plot(D*f)

%% 
% Another important chebop building block is the chebfun diag method, which
% creates an operator representing pointwise multiplication by that
% function.
F = diag(f);
g = log(2+x);
norm( F*g - f.*g )

%%
% Chebops respond to arithmetic operations much as matrices do. Both the
% underlying matrices and functional representations are kept up to date.
J = 4 + Q*F;
norm( J*g - (4*g + cumsum(f.*g)) )

%% 7.4 Solving linear equations
% The backslash operator works on linear chebops much as it does on matrices, to
% solve a linear system. In this case, the system may be an integral or
% differential one. For instance, we can transform the differential
% equation
% 
% u'(x) + f(x)u(x)=0,  u(0)=-2
% 
% into an integral equation,
% 
% v(x) + f(x) ( -2 + INT_0^x v(s) ds ) = 0,
% 
% which can be solved by
K = I + F*Q;
v = K \ (2*f);
u = -2 + Q*v;
clf, plot(u)
title( ['residual norm = ' num2str( norm((D+F)*u) ) ] )

%%
% Differential operators are not generally invertible in the absence of 
% auxiliary conditions. In order to solve the original differential
% equation more directly, we can form the differential operator, assign it
% a boundary condition, and finally use backslash. 
A = D + F;
A.lbc = -2;
u = A \ 0;
clf, plot(u)
title( ['residual norm = ' num2str( norm((D+F)*u) ) ] )

%%
% Note in the above that A.lbc was used to assign a condition on the
% solution at the left endpoint of the domain, and the scalar 0 is
% automatically "expanded" into a constant chebfun on the domain. 

%%
% In order to assign a Neumann condition on the solution at the
% right endpoint, we clear the old condition and proceed as follows.
A.lbc = [];  A.rbc = D;
u = A\1;
clf, plot(u)

%% 
% In general, if a number is given as a boundary condition, it is imposed
% as a Dirichlet condition on the solution; if an operator is given, it is
% applied homogeneously to the solution; and if {operator,number} are given
% in a cell array, the operator applied to the solution equals that number
% at the boundary. One can alternatively use the strings 'dirichlet' or
% 'neumann' anywhere an operator would be accepted. 
A.rbc = 'neumann';   % same as previous example
A.rbc = {D-4*I, 5};  % so that u'(1)-4u(1)=5

%%
% For second-order differential operators, one can assign to .lbc and .rbc
% separately, or one can use .bc to apply the same condition at both ends. 
f = sin(2*pi*x);
A = D^2 - D + diag(1000*x.^2);
A.bc = 'dirichlet';
u = A\f;  plot(u)

%%
% The assignment A.bc above applies to both boundaries. A synonym for the
% .bc assignment is to use the & operator:
u = (A & 'neumann') \ f;  hold on, plot(u,'k')

%%
% One can also retrieve boundary conditions as a structure, then assign
% them to another operator. 
bc = A.bc;
u = ( (A+40) & bc ) \ f;  plot(u,'r')

%%
% Moreover, there is a special boundary condition string 'periodic' that
% will find a periodic solution, provided that the right-side function is also
% periodic.
u = ( A & 'periodic') \ f;  plot(u-0.1,'m.-')  

%%
% For all the details on how to assign boundary conditions, see the help 
% for linop/and.

%% 7.5 Eigenvalue problems
% The eigs command is overloaded to find some of the eigenvalues and
% eigenfunctions of a chebop. 
d = domain(0,pi);  D = diff(d);
[V,D] = eigs(D^2 & 'dirichlet');
diag(D)
clf, plot(V(:,1:4))

%%
% By default, eigs tries to find the six eigenvalues that are "most readily
% converged to". You can change the number sought and tell eigs where to
% look for them. Note, however, that you can easily confuse eigs if you ask
% for the wrong eigenvalues--such as finding the largest eigenvalues of a
% differential operator.

%%
% Here are eigenvalues of the Mathieu equation, and the resulting elliptic
% sines and cosines. Note the imposition of periodic boundary conditions.
q = 10;
[d,x] = domain(-pi,pi);  
A = diff(d,2) - 2*q*diag(cos(2*x)) & 'periodic';
[V,D] = eigs(A,30,'lr');  % values with largest real part
subplot(1,2,1), plot(V(:,1:2:5)), title('elliptic cosines')
subplot(1,2,2), plot(V(:,2:2:6)), title('elliptic sines')

%%
% eigs can also solve generalized eigenproblems. Here is an example of modes
% from the Orr-Sommerfeld equation of hydrodynamic linear stability
% analysis at parameters very close to the onset of instability. This is a
% fourth-order problem, requiring two conditions at each boundary.
[d,x] = domain(-1,1); 
D = diff(d);  I = eye(d);

R = 5772;
A = (D^4-2*D^2+I)/R - 2i - 1i*diag(1-x.^2)*(D^2-I);
B = D^2-I;

A.lbc(1) = I;  A.lbc(2) = D;
A.rbc(1) = I;  A.rbc(2) = D;

lam = eigs(A,B,40,'lr');
clf, plot(lam,'r.'), grid on, axis equal
max(real(lam))

%% 7.6 Exponential  of an operator
% Another means of creating a chebop is intimately tied to the solution of
% time-dependent PDEs: the exponential of a linear operator (i.e., the
% semigroup generated by the operator). For example, we might advance the
% solution of the heat equation as follows.
[d,x] = domain(-1,1); 
A = diff(d,2);  
f = exp(-20*(x+0.3).^2);
clf, plot(f,'r'), hold on, c = [0.8 0 0];
for t = [0.01 0.1 0.5]
  E = expm(t*A & 'dirichlet');
  plot(E*f,'color',c),  c = 0.5*c;
end

%%
% Here is a more fanciful analogous computation
% with a complex initial function obtained from the "scribble"
% command introduced in Chapter 5.  (As it happens "expm" does
% not map non-smooth data with the usual chebfun accuracy, so
% warning messages are generated.)

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

%%
% Unlike the chebops created previously in this chapter, the operator
% exponential does not have an infinite-dimensional representation. 

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
% condition numbers close to 1, we cannot expect the resulting solutions
% to be accurate to full machine precision. Typically one loses just a
% few digits for second-order differential problems, but six or more digits
% for fourth-order problems. 

%% 7.8 Nonlinear equations by Newton iteration
% As mentioned at the beginning, nonlinear
% differential equations are discussed in Chapter 10.  As an indication of some
% of the possibilities, however, we now illustrate how 
% a sequence of linear problems may be useful in solving nonlinear
% problems. For example, the nonlinear BVP
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
% Note the beautifully fast convergence, as one expects with Newton's method.
% The chebop J is a Jacobian (=Frechet derivative) operator, which we have
% constructed explicitly by differentiating the nonlinear operator defining the
% ODE.  In Section 10.4 we shall see that this process can be automated by use
% of chebfun's "nonlinear backslash" capability, which in turn utilizes a
% built-in chebfun Automatic Differentiation (AD) feature.  In Section 10.2
% we shall see that
% it is also possible to solve such problems with the chebfun overloads of
% the Matlab boundary-value problem solvers bvp4c and bvp5c.

%%
% The line "J.scale=norm(u)" in the code above tells the constructor for the \
% solution that delta needs to be found accurately only relative to the
% size of u, not relative to its own size. As u approaches the correct
% value, the norm of delta gets small and therefore delta does not require much
% intrinsic resolution in order to make the proper correction to u.

%% 7.9 Systems of equations and block operators
% Chebops support some functionality for systems of equations. 
% Here is an eigenvalue example:
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
% [Driscoll, Bornemann & Trefethen 2008] T. A. Driscoll, F. Bornemann, and L. N. Trefethen,
% "The chebop system
% for automatic solution of differential equations", BIT Numerical Mathematics 46 (2008),701-723.
%
% [Fornberg 1996] B. Fornberg, A Practical Guide to Pseudospectral Methods,
% Cambridge University Press, 1996.
%
% [Trefethen 2000] L. N. Trefethen, Spectral Methods in MATLAB, SIAM, 2000.
