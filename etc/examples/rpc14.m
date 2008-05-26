%% rpc14 Draw a spherical spiral
%%       Ricardo Pachon, 12/06

t = chebfun(@(t) t, [0 2*pi]);
x = cos(t).*cos(24*t);
y = cos(t).*sin(24*t);
z = sin(t);
plot3(x,y,z,'LineWidth',2)
box on, axis equal
disp('type <Enter> to see the dance')
pause, comet(x,y,z)