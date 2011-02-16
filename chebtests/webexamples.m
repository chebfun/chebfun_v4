function pass = webexamples
% Test the examples that are on the front page of the Chebfun website
tol = 10*chebfunpref('eps');

% What's the integral of sin(sin(x)) from 0 to 10? 
x = chebfun('x',[0 10]);
sum(sin(sin(x)));
pass(1) = abs(ans - 1.629603118459496) < tol;

% What's the maximum of sin(x)+sin(x2) over the same interval?
max(sin(x)+sin(x.^2));
pass(2) = abs(ans - 1.985446580874100) < tol;

% How many roots does the Bessel function J0(x) have between 0 and 1000?
% length(roots(chebfun(@(x) besselj(0,x),[0 1000])));
% pass(3) = ~(ans-318);

[d,x] = domain([-20,20]); L = diff(d,2)-diag(x)&'dirichlet';% plot(L\1)
pass(3) = abs(feval(L\1,-5) - 1.981471116055969) < 50*tol;