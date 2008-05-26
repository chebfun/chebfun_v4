% rpc12 Draw a 3D curve and computes its curvature 
% and torsion (which are equal).
% Doesn't converge for |t| > 1.7
t = chebfun(@(t) t, [-1.7 1.7]);
x = 3*t - t.^3;
y = 3*t.^2;
z = 3*t+t.^3;
plot3(x,y,z,'LineWidth',2)
box on
disp('Press ENTER to continue')
pause
plot(curvature({x;y;z}))
hold on
plot(torsion(x,y,z),'r')
hold off