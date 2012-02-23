function pass = chebop_eigs
% Test the chebop eigs method.
% Asgeir Birkisson, December 2010

%% With linops
d = domain(0,pi);
L = diff(d,2) & 'dirichlet';
[V,D] = eigs(L,3);
diag1 = sqrt(-diag(D));

%% With chebops
d = [0,pi];
N = chebop(d);
N.op = @(u) diff(u,2);
N.bc = 'dirichlet';
[V,D] = eigs(N,3);

diag2 = sqrt(-diag(D));

pass = norm(diag1-diag2) == 0;
