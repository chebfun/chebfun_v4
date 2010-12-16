function pass = chebopeigs
% Test for chebop eigs method.
% Asgeir Birkisson, December 2010

%% With linops
[d,x,N] = domain(0,pi);
L = diff(d,2) & 'dirichlet';
[V,D]=eigs(L,10);
diag1 = sqrt(-diag(D));

%% With chebops
[d,x,N] = domain(0,pi);
N.op = @(u) diff(u,2);
N.bc = 'dirichlet';
[V,D]=eigs(N,10);

diag2 = sqrt(-diag(D));

pass = norm(diag1-diag2) == 0;