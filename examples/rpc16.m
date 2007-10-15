% rpc16 Draw a tube around a torus knot 
t = chebfun('t', [0 2*pi]);
a = 8; b = 3; c = 5; p = 2; q = 5; % (clover knot)
x = (a + b*cos(q*t)).*cos(p*t);
y = (a + b*cos(q*t)).*sin(p*t);
z = c*sin(q*t);
plot3(x,y,z,'LineWidth',2)
box on
axis tight