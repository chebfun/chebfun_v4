% lnt13.m - evaluate Riemann zeta function on
%           critical line   LNT & RP   12/06
% zeta = @(z) sum((1:10000).^(-z));
% zetaexp = @(z) zeta(exp(z)+1);
% NOT AVAILABLE YET!
f = chebfun(@(z) (z-1).*zeta(z), [2,3]);
z = chebfun('z',[2 3]);
za = @(x) f(.5+i*x)./(i*x-.5);
x = linspace(10,20);
cx = log(x*1i-0.5);
fcx = f(cx);
plot(x,real(fcx)); hold on
plot(x,imag(fcx),'r'); 
plot(x,abs(fcx),'k'); hold off
% norm(imag(f_critical))                     % should this be 0?
% f_critical = real(f_critical)              % if so, this cleans up rounding errors?
% plot(f_critical)