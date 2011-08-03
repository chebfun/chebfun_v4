function pass = chebop_svds
% Test the chebop svds method.
% Nick Hale, August 2011

tol = 1e-9;

%% SVD of a Fredholm operator
[d x] = domain(0,pi);
F = fred(@(x,y) sin(x-y),d);
S = svds(F);

pass(1) = numel(S) == 2 && norm(S - pi/2) < tol;


%% SVD of D and Eigs of D2
D1 = chebop(@(u) diff(u));
[U S V] = svds(D1,6,1);
s = diag(S);

D2 = chebop(@(u) -diff(u,2),'dirichlet','dirichlet');
[V D] = eigs(D2,6,1);
e = flipud(sqrt(diag(D)));

pass(2) = norm(s-e,inf) < tol;


%% SVD of D2 with boundary conditions
[U S V] = svds(D2,6,1);
s = 2*sqrt(diag(S))/pi;

pass(3) = norm(s-(1:6)',inf) < tol;
