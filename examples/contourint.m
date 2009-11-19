% contourint.m  evaluate a keyhole contour integral

c = [-2+.05i -.2+.05i -.2-.05i -2-.05i];
s = chebfun('s',[0 1]);
z = [c(1)+s*(c(2)-c(1))
     c(2)*c(3).^s./c(2).^s
     c(3)+s*(c(4)-c(3))
     c(4)*c(1).^s./c(4).^s];
clf, plot(z), axis equal, axis off
f = log(z).*tanh(z);
I = sum(f.*diff(z)), Iexact = 4i*pi*log(pi/2)
