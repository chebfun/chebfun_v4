% chebfundemo.m = a few commands to illustrate
%    the chebfun system (i.e., chebfuns enhanced to work
%    on arbitrary intervals, and with functions that
%    need only be piecewise continuous)
%
%    Ricardo Pachon and Nick Trefethen, January 2006

t = chebfun(@(t) t,[-pi,pi]);
f = sin(2*t) + cos(t) - (sin(cos(t).^2));
plot(f)
comet(f)
g = sign(f);
hold on, plot(g,'r')
g = cos(3*t) + asinh(t);
hold off, plot(g,'g')
hold on, plot(f,'b')
h = max(f,g);
plot(h,'k')
comet(h)
r = roots(h)
plot(r,h(r),'or','markersize',16)
f = max(t,t+sin(5*t));
hold off, plot(f)
comet(f)