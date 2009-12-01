function f = vandermonde( n , fin )

% Input:  number of random nodes over which to interpolate and an optional
%         function to interpolate. If no function is input, sin(exp(2*xi))
%         is used by default.
% Output: the chebfun created by interpolating fin at n random nodes on
%         [-1,1].

%% create a set of random nodes and function values
if nargin == 0, n = 32; end
xi = 2*rand(n,1) - 1;
if nargin < 2, fx = sin(exp(2*xi));
else fx = fin(xi); end;

%% create the basis of Chebyshev polynomials
T = chebpoly(0:n-1);

%% solve the Vandermonde-like system of equations
c = T(xi,:) \ fx;

%% create the chebfun from the coefficients
f = chebfun( chebpolyval( flipud(c) ) );

%% plot the result
if nargin < 2, plot(f);
else plot([f,fin]); end;
hold on; plot(xi,fx,'or'); hold off;

%% how far off are we at the nodes?
disp(sprintf('inf-norm of interpolation error at the nodes is %e.',norm(f(xi)-fx,inf)));