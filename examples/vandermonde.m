function f = vandermonde( xi , fx )

%  Input: a set of nodes xi in [-1,1] and function values fx,
% Output: the chebfun created by interpolating fin at n random nodes on
%         [-1,1].


%% create a set of random nodes and function values (if not supplied)
if nargin < 1
    n = 20;
    xi = 2*rand(n,1) - 1;
else
    n = length(xi);
end;
if nargin < 2
    fx = sin(exp(2*xi));
end;

%% create the basis of Chebyshev polynomials
T = chebpoly(0:n-1);

%% solve the Vandermonde-like system of equations
c = T(xi,:) \ fx;

%% create the chebfun from the coefficients
f = chebfun( chebpolyval( flipud(c) ) );

%% plot the result
if nargin < 2
    subplot(2,1,1); plot([f,chebfun(@(x)sin(exp(2*x)))]); hold on; plot(xi,fx,'or'); hold off; title('interpolation of sin(exp(x))');
    subplot(2,1,2); plot(f-chebfun(@(x)sin(exp(2*x)))); hold on; plot(xi,0,'or'); hold off; title('interpolation error');
else
    plot(f); hold on; plot(xi,fx,'or'); hold off;
end;

%% how far off are we at the nodes?
disp(sprintf('inf-norm of interpolation error at the nodes is %e.',norm(f(xi)-fx,inf)));