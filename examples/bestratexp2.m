function [p q s] = bestratexp2(N,flag)
% BESTRATEXP2   Best rational approximation to exp(-x^2) on (-inf,inf)
%  [P Q] = bestratexp2(N) computes the near-best rational approximation
%  P(x)/Q(x) of degree N (where N is even) to exp(-x^2) on (-inf,inf).
%
%  [P Q S] = bestratexp2(N) returns also the error in the apprioximation and
%  [P Q] = bestratexp2(N,'plot') or [P Q S] = bestratexp2(N,'plot') plots
%  also the equioscillation of the error.
%
%  The method used is Carathéodory-Féjer approximation (cf), which yields
%  rational approximants that are near-best but so close to best that the
%  difference is below machine precision. The function exp(-x^2) is mapped 
%  to [-1,1] to do the approximation.

%  Joris Van Deun

if nargin == 0
    N = 6;
end

f = chebfun('exp(9*(t-1)./(t+1))');
[p,q,s] = cf(f,N,N);

if nargin == 2
    x = linspace(-20,20,10000);
    plot(x,exp(-x.^2)-p((1-x.^2)./(1+x.^2))./q((1-x.^2)./(1+x.^2))); hold on; 
    plot([-20,20],[s,s],'k',[-20,20],[-s,-s],'k'); hold off
end