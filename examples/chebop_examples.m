%% Examples of chebop usage

%% Three basic operators
d = domain(-1,1);
I = eye(d);
D = diff(d);
J = cumsum(d);

%%
f = chebfun('exp(2*x)',d);
norm( D*f - 2*f )
norm( J*f - (f/2-exp(-2)/2) )

%%
% The A* syntax applies infinite-dimensional forms of the operators.
norm( D*f - diff(f) )  % exactly the same

%% 
% We can extract the finite- or infinite-dimensional realizations.
J{8}

%%
J{inf}

%% 
% The operators can be defined for functions on other domains. For the time
% being, the interval must be specified at creation. This may change in the
% future.
d2 = domain(0,1);
D2 = diff(d2);
D{5}

%%
D2{5}


%% Diagonal operators
g = chebfun('sin(4*x.^2)',d);
G = diag(g);
G{6}   % sparse diagonal
norm( G*f - g.*f )   % exactly the same

%% Operator aritmetic
A = I + J*G;
norm( A*f - (f+cumsum(g.*f)) )    % exactly the same

%%
B = 2-I;  
B{6}

%%
B = D^3;  
norm( B*f - diff(f,3) )     % exactly the same

%%
B = D^0;  B{6}      % note the sparse identity

%% Solving equations using \

%% 2nd order BVP
% Homogeneous Dirichlet.
f = chebfun('cos(pi*x)-sin(2*pi*x)',d);
A = 0.5*D^2 + G;
A.bc = 'dirichlet';
u = A\f;
resid = norm( 0.5*diff(u,2) + g.*u - f )
clf, plot(u)

%%
% The realizations of this operator make it clear that the first and last
% components are assigned values by the BC, not the ODE.
A{5}

%%
% Note the warning here.
A{inf}

%%
% Homogeneous Neumann.
A.bc = 'neumann';
u = A\f;
resid = norm( 0.5*diff(u,2) + g.*u - f )
plot(u)
feval( diff(u), [-1 1] )

%%
% Nonhomogeneous conditions specified at each end.
A.lbc = 4;
A.rbc = {D,3};
u = A\f;
resid = norm( 0.5*diff(u,2) + g.*u - f )
plot(u)
feval( diff(u), [1] )

%% 
% Periodic.
A.bc = 'periodic';
u = A\f;
plot(u)
feval(u,[-1 1])
feval(D*u,[-1 1])

%%
% Inappropriate BC--note the warning you receive.
A.rbc = [];
u = A\f;

%% 4th order BVP and eigenvalues
A = 0.01*D^4 + 100*G;
A.lbc = 0; 
A.lbc(2) = {D,-10};
A.rbc = 0;
A.rbc(2) = {D^2,0};
u = A\f;
plot(u)
feval(diff(u),-1)
feval(diff(u,2),1)

%%
% Eigenvalue problems automatically assume homogeneous forms of the BCs.
[V,L] = eigs(A);
for j = 1:6
  subplot(3,2,j)
  plot(V{j})
  title(sprintf('%.12f',L(j,j)))
end

%% Newton iteration for an IVP
f = @(u) 1-atan(4*u);
dfdu = @(u) -4./(1+(4*u).^2);
d = domain(0,5);
J = cumsum(d);
I = eye(d);
u = chebfun(-1,d);
for k = 1:10
  r = u - J*f(u) + 1;
  norm(r)
  A = I - J*diag(dfdu(u));
  A.scale = norm(u);
  delta = -(A\r);
  u = u+delta;
end
clf, plot(u)



