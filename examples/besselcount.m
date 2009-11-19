function n = besselcount(a,b,plt)

% Returns the number of roots of the Bessel function J_0 in
% the interval [a,b].  If a third input is given a plot is drawn.
% For example, compare besselcount(0,1000) and (1000000,1001000).

u = chebfun(@(x) besselj(0,x),[a b]);
n = length(roots(u));
if nargin==3, plot(u), grid on, end
