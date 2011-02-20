function pass = ivp1
% This tests solves a linear IVP using chebop and checks
% that the computed solution is accurate.
% First it does the job with Version 3 syntax (linops).
% Then it does it again with Version 4 syntax (chebops).

tol = chebfunpref('eps');

% Linop version:

d = domain(-1,1);
x = chebfun(@(x) x,d);
I = eye(d);
D = diff(d);
A = (D-I) & {'dirichlet',exp(-1)-1};
u = A\(1-x);
pass(1) = norm( u - (exp(x)+x) ) < 100*tol;

% Chebop version:

d = [-1,1];
x = chebfun(@(x) x,d);
A = chebop(@(u) diff(u)-u,d);
A.lbc = exp(-1)-1;
u = A\(1-x);
pass(2) = norm( u - (exp(x)+x) ) < 100*tol;
