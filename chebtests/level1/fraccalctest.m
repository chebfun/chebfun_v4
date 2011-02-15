function pass = fraccalc
% Perform some tests for fractional derivatives
% Nick Hale, Feb 2010

tol = 100*chebfunpref('eps');

% polynomials
x = chebfun('x',[0 1]);
q = sqrt(2)/2;
k = 0;
for n = [1 5]
    k = k+1;
    xn = x.^n;
    xnpq = diff(xn,q);
    true = gamma(n+1)./gamma(n+1-q)*chebfun(@(x) x.^(n-q),[0 1],'exps',[n-q 0]);    
    pass(k) = norm(true-xnpq,inf) < tol;
end

% exponential
u = chebfun('exp(x)',[0 1]);
up05 = diff(u,.5);
uint05 = cumsum(u,.5);
true = chebfun('erf(sqrt(x)).*exp(x)',[0 1],'exps',[.5 0]);
pass(3) = norm(true-up05,inf) < tol;
pass(4) = norm(true-uint05,inf) < tol;
