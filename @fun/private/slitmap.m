function [g] = slitmap(z,d,e,deriv)
% SLITMAP - conformal map to slit region
%  G = SLITMAP(X,D,E) returns the values G of the conformal map from an 
%  ellipse with foci +1,-1 to complex plane minus the vertical congugate 
%  slits with tips at D+1iE evaluated at the points X.
%
%  [G GP] returns also the derivative values at those points.

if deriv
    z(z == -1) = -1+eps;
    z(z == 1) = 1-eps;
end

c = sign(d)*realsqrt(0.5*((d^2+e^2+1)-realsqrt((d^2+e^2+1)^2-4*d^2)));
s = realsqrt(1-c^2);
m14 = (-e+realsqrt(e^2+s^2))/s;   m = m14^4;
K = ellipke(m);
[sn cn dn] = ellipj(2*K*asin(z)/pi,m);
h1 = m14*sn;
h1p = 2*K/pi*m14*(cn.*dn)./sqrt(1-z.^2);
if ~deriv
    g = c/m14+((1-m14^2)/m14)*(h1-c)./(1-h1.^2);
else
    g = (1-m14^2)/m14*h1p.*(1+h1.^2-2*c*h1)./(1-h1.^2).^2;
end