function n = besselcount(a,b)

% Returns the number of roots of the Bessel function J_0 in
% the interval [a,b].  If a third input is given a plot is drawn.
% For example, compare besselcount(0,1000) and (1000000,1001000).

if nargin == 0,
    a = 0;       b = 1000;
%     a = 1000000; b = 1001000;
end

u = chebfun(@(x) besselj(0,x),[a b]);
n = length(roots(u));
if nargin==3 || nargin == 0 , plot(u,'numpts',3*pi*(b-a)), grid on, end
