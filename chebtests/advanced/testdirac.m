function pass = testdirac
% Tests the construction of the Dirac-Delta function on bounded domains
%
% Mohsin Javed, May 2012
% (A Level 1 Chebtest)

tol = chebfunpref('eps');
x = chebfun('x');

d = dirac(x-2);              % No impulse, zero chebfun
pass(1) = all(abs(d.imps(2,:)) < 100*tol );

d = dirac(x);                % Impulse of unit magnitude at x=0
pass(2) = abs(d.imps(2,2)-1) < 100*tol;

d = dirac((1-x.^2));         % Impulses of magnitued 1/2 at -1 and 1
pass(3) = all( abs(d.imps(2,:) - .5) < 100*tol );

d = dirac(sin(pi*x));        % Impulses of magnitude 1/pi at -1, 0 and 1
pass(4) = all( abs(d.imps(2,:) - [1/pi 1/pi 1/pi]) < 100*tol );

d = dirac((x.^3-x).*exp(x)); % Impulses at -1, 0 and 1
pass(5) = all( abs(d.imps(2,:) - [exp(1)/2 1 1/(2*exp(1))]) < 100*tol);
    