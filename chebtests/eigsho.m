function pass = eigsho
% Check simple Laplacian eigenvalues.
%   Toby Driscoll, updated Oct 13, 2010

tol = chebfunpref('eps');
d = domain(0,pi);
A = diff(d,2) & 'dirichlet';
[V,D] = eigs(A,10);
lam = diag(D);
k = sqrt(-lam);

pass(1) = norm( k - (1:10)', Inf ) < 1000*tol; 
pass(2) = norm( A*V(:,1) - V(:,1)*D(1,1) ) < 1e6*tol;
pass(3) = abs(norm(V(:,1))-1) < 1000*tol;



