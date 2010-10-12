%% FOX-LI EIGENVALUES
% Toby Driscoll and Nick Trefethen, 7 October 2010

%%
% (Chebfun example integro/FoxLi.m)

%%
% In the field of optics,
% integral operators arise that have a complex symmetric
% (but not Hermitian) oscillatory kernel.  An example is
% the following linear operator L associated with the names of Fox and Li
% (also Fresnel and H. J. Landau).  This operator maps a function
% u defined on [-1,1] to another function v = Lu defined on [-1,1];
% the number F is a positive real parameter, the Fresnel number.
%
% v(x) = sqrt(i*F/pi) int_1^1 exp(-i*F*(x-s)^2) u(s) ds.

%%
% The following Chebfun code computes the largest 80 eigenvalues
% of L in the case F = 64*pi.  The dashed red cirve is the unit circle.
tic, [d,x] = domain(-1,1);
F = 64*pi; A = sqrt(1i*F/pi) * fred( @(x,s) exp(-1i*F*(x-s).^2 ), d );
clf, plot(exp(1i*pi*x),'--r','linewidth',1.6)
hold on, plot(eigs(A,80,'lm'),'k.','markersize',16)
title('Largest 80 eigenvalues of Fox-Li operator','fontsize',14)
axis equal, axis off, toc

%%
% References:
%
% T. A. Driscoll, Automatic spectral collocation for integral,
% integro-differential, and integrally reformulated differential
% equations, Journal of Computational Physics 229 (2010), 5980-5998.
% DOI: 10.1016/j.jcp.2010.04.029
%
% A. G. Fox and T. Li, Resonant modes in a maser interferometer,
% Bell System Technical Journal 40 (1961), 453-488.
%
% L. N. Trefethen and M. Embree, Spectra and Pseudospectra,
% Princeton University Press, 2005 (Chapter 60).

