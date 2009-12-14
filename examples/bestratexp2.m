function [p q s] = bestratexp2(N,flag)
% BESTRATEXP2   Best rational approximation to exp(-x^2) on (-inf,inf)
%  [P Q] = bestratexp2(N) computes the near-best rational approximation
%  P(x)/Q(x) of type (N,N) to exp(-x^2) on (-inf,inf), when N is even.
%
%  [P Q S] = bestratexp2(N) returns also the error in the approximation and
%  [P Q] = bestratexp2(N,'plot') or [P Q S] = bestratexp2(N,'plot') plots
%  also the error (which equi-oscillates).
%
%  The method used is Caratheodory-Fejer approximation (cf), which yields
%  rational approximants that are near-best but so close to best that the
%  difference is below machine precision. The function exp(-x^2) is mapped 
%  to [-1,1] to do the approximation.
%
%  P and Q are chebfuns on [-1,1], but can be evaluated outside this
%  interval. To obtain the coefficients in a monomial basis, use POLY.
%
%  The implementation is partially based on L.N.Trefethen, J.A.C. Weideman
%  and T. Schmelzer, "Talbot quadratures and rational approximations", BIT
%  Numerical Mathematics (2006) 46:653-670.

%  Joris Van Deun

if nargin == 0
    N = 12;
end

if mod(N,2), error('CHEBFUN:bestratexp2:N_odd','N must be even.'); end

f = chebfun('exp(9*(t-1)./(t+1))');
[p,q,r,s] = cf(f,N/2,N/2);

if nargin == 2 || nargin == 0
    x = linspace(-20,20,10000);
    plot(x,exp(-x.^2)-p((9-x.^2)./(9+x.^2))./q((9-x.^2)./(9+x.^2))); hold on; 
    plot([-20,20],[s,s],'k',[-20,20],[-s,-s],'k'); hold off
end

if nargout > 0
    p = chebfun(@(x) (9+x.^2).^(N/2).*p((9-x.^2)./(9+x.^2)),N+1);
    q = chebfun(@(x) (9+x.^2).^(N/2).*q((9-x.^2)./(9+x.^2)),N+1);
end
