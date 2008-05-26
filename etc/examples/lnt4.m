% lnt4.m  Find zeros of Bessel function J0  -  LNT 12/2005
 
 bessf = @(x) besselj(0,x);
 f = chebfun(bessf,[0,50]);
 hold off, plot(f,'.-')
 r = roots(f)
 hold on, plot(r,f(r),'or'), grid on;
 hold off