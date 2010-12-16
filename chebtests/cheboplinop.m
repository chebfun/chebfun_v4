function pass = cheboplinop
% Test for chebop linop method.
% Asgeir Birkisson, December 2010

% Create a linop, u -> u''+x*u, u'(0) = u'(2) = 0
[d x] = domain(0,2);
L1 = diff(d,2)+diag(x);
L1.bc = 'neumann';

% Create a chebop representing the same operator
N = chebop(d);
N.op = @(u) diff(u,2)+x.*u;
N.bc = 'neumann';
% Convert to linop
L2 = linop(N);

% Compare the results
pass = norm(L1(10)-L2(10)) == 0;

