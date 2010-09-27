% Eigenvalues of a Fresnel integral operator in the analysis of lasers.
% See chapter 60 of Trefethen and Embree.

% Toby Driscoll, July 6, 2010

[d,x]=domain(-1,1);
F = 64*pi; A = sqrt(1i*F/pi) * fred( @(x,s) exp(-1i*F*(x-s).^2 ), d );
plot(eigs(A,100,'lm'),'b.','markersize',12), axis equal, axis square
hold on, plot(exp(1i*(0:0.01:2)*pi),'k-')
