% EXPANDING CHEBFUN
% Ricardo Pachon 13-12-2006
% New functions

% CHEBFUN EXPANSION TO PWS-FUNCTIONS
% As described in the previous memo, the following are the new features of
% chebfun:

% - chebfun from an .m file
% - compose(f,g)
% - curvature
% - torsion
% - fixcurve
% - plot(f,g)
% - plot3(f,g,h)

% APPLICATIONS OF RICFUN
% The following are the codes of some examples of chebfun in basic
% differential geometry:

%% EXAMPLES OF PLANE CURVES --------------------
% some parametrized curves in chebfun
t = chebfun('t', [0 2*pi]);
x = sin(t);
y = sin(t).*cos(t);
% Bernoulli's lemniscates (choose a>=1)
t = chebfun('t', [0 2*pi]);
a = 2;
x = a * cos(t) ./ ( 1 + sin(t) .^ 2); 
y = a * sin(t) .* cos(t) ./ (1 + sin(t) .^ 2);
% cycloids
t = chebfun('t', [0 2*pi]);
x = t - sin(t);
y = 1 - cos(t);
% cardioids (choose a>=1)
t = chebfun('t', [0 2*pi]);
a = 2;
x= 2 * a * cos(t) .* (1 + cos(t));
y = 2 * a * sin(t) .* (1 + cos(t));
% dimonds (choose a>=0)
t = chebfun('t', [0 2*pi]);
a = 2;
x = abs(cos(t)) .^ ( a - 1 ) .* cos(t);
y = abs(sin(t)) .^ ( a - 1 ) .* sin(t);
% clothoids power a 
t = chebfun('t',[-10 10]);
a = 2;
x = cumsum(sin(t.^a/a));    
y = cumsum(cos(t.^a/a));    
% tractrix (doesn't converge with chebfuns)
t = chebfun('t',[0 3]);
x = sin(t);
y = cos(t) + log(tan(t/2));
% Diocles' cissoid
t = chebfun('t');
x = 2*t.^2./(1+t.^2);
y = 2*t.^3./(1+t.^2);
% --------------------------------------------
% CURVES DEFINED FROM THEIR CURVATURE
% t + sin(t)
t = chebfun('t', [-20 20]);
kappa = t + sin(t);
[x,y] = fixcurv(kappa);
% sin(t)
t = chebfun('t', [-20 20]);
kappa = sin(t);
[x,y] = fixcurv(kappa);
% t*sin(t)
t = chebfun('t', [-20 20]);
kappa = t.*sin(t);
[x,y] = fixcurv(kappa);
% t^2 * sin(t) 
t = chebfun('t', [-8 8]);
kappa = t.^2.*sin(t);
[x,y] = fixcurv(kappa);
% t*(sin(t))^2
t = chebfun('t', [-20 20]);
kappa = t.*(sin(t)).^2;
[x,y] = fixcurv(kappa);
% squarewave
t = chebfun('t',[-10*pi 10*pi]);
kappa = sign(sin(t));
[x,y] = fixcurv(kappa);
%% EXAMPLES OF CURVES IN 3D --------------------
% twisted cubic
t = chebfun('t', [0 1]);
x = t;
y = t.^2;
z = t.^3;
plot(curvature(x,y,z))
hold on
plot(torsion(x,y,z),'r')
% simple example
t = chebfun('t', [-2 2]);
x = 3*t - t.^3;
y = 3*t.^2;
z = 3*t+t.^3;
% helical (torsion doesn't converge)
t = chebfun('t', [0 5*pi]);
a = 1; b = .08;
x = a*exp(b*t).*cos(t);
y = a*exp(b*t).*sin(t);
z = .5*t;
% Viviani's curve
t = chebfun('t', [0 2*pi]);
x = 1 + cos(t);
y = sin(t);
z = 2*sin(t/2);
% spherical spiral
t = chebfun('t', [0 2*pi]);
x = cos(t).*cos(24*t);
y = cos(t).*sin(24*t);
z = sin(t);