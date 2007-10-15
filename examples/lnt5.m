
% lnt5.m Compute perimeter of ellipse - LNT 12/2005
%
% The ellipse we use is the one used by Poisson in his
% paper of 1826, with semiaxis lengths .5/pi and .4/pi.
% We know thanks to M. Poisson that the perimeter should be
% 0.90277992777219...

exact = 0.90277992777219
theta = chebfun(@(theta) theta,[0,2*pi]);
x = (.5/pi)*cos(theta);
y = (.4/pi)*sin(theta);
plot(x,y,'.-'), axis equal
arc_length = norm(sqrt(diff(x).^2+diff(y).^2),1)