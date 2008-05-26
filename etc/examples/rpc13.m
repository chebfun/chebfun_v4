% rpc13 Draw a 3D helix and computes its curvature 
% and torsion (with b = 0, the curve is a circular helix).
% Doesn't converge for t > 3*pi !!!
t = chebfun(@(t) t, [0 3*pi]);
a = 1; b = .1;
x = a*exp(b*t).*cos(t);
y = a*exp(b*t).*sin(t);
z = .5*t;
plot3(x,y,z,'LineWidth',2)
box on
axis tight
disp('Press ENTER to continue')
pause
plot(curvature({x;y;z}),'LineWidth',2)
hold on
plot(torsion(x,y,z),'r','LineWidth',2)
hold off
axis tight