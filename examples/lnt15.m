% lnt15 - global maximum and minimum

x = chebfun(@(x) x,[-2 2]);
f = sin(20*x)./(1+exp(x)+x.^2);
half = (1+sign(x))/2;
g = half.*f + .3*(abs(x)-.2*x);
hold off, plot(g), hold on, grid on
[a,b] = max(g), plot(b,a,'or','markersize',14);
[a,b] = min(g), plot(b,a,'or','markersize',14);
hold off
