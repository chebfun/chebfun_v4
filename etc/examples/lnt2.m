% lnt2.m  Find x such that x = cos(x) - LNT 12/2005

 x = chebfun(@(x) x,[-2*pi,2*pi]);
 cosx = cos(x);
plot(x,'-k')
 hold on, plot(cosx,'-.b'); axis tight, 
 r = roots(x-cosx)
 plot(r,x(r),'or','markersize',16)
 error = r - cos(r)
 hold off