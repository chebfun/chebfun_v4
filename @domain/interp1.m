function p = interp1(xk,yk,d)  
%  P = INTERP1(X,F), where X is a vector and F is a chebfun,
%  returns the chebfun P defined on domain(F) corresponding
%  to the polynomial interpolant through F(X(j)) at points X(j).
%
%  P = INTERP1(X,Y,D), where X and Y are vectors and D is a
%  domain, returns the chebfun P defined on D corresponding
%  to the polynomial interpolant through data Y(j) at points X(j).
%
%  For example, these commands plot the interpolant in 11 equispaced
%  points on [-1,1] through a famous function of Runge:
%
%  d = domain(-1,1);
%  ff = @(x) 1./(1+25*x.^2);
%  x = linspace(-1,1,11);
%  f = chebfun(ff,d);
%  p = interp1(x,ff(x),d)
%  hold off, plot(f,'k')
%  hold on, plot(p,'r')
%  grid on, plot(x,p(x),'.r'

%  This version of INTERP1 lives in @domain.
%  There is a companion code in @chebfun.
%
%  Nick Trefethen & Ricardo Pachon,  24/03/2009

w = bary_weights(xk);
a = d.ends;
p = chebfun(@(x) bary(x,xk,yk,w),a([1 end]),length(xk));

function p = bary(x,xk,pk,w)               % barycentric interpolation
p = zeros(size(x));
numer = p; denom = p; exact = p;
I = true(size(x));                         % x(i)=false if x(i)=xk(j), some j
for j = 1:length(xk)
  xdiff = x-xk(j);
  ii = find(xdiff==0);
  exact(ii) = j;
  I(ii) = false;
  tmp = w(j)./xdiff(I);
  numer(I) = numer(I) + tmp*pk(j);
  denom(I) = denom(I) + tmp;
end
p(~I) = pk(exact(~I));
p(I) = numer(I)./denom(I);

function w = bary_weights(xk)
n = length(xk);
w = ones(n,1);
for i = 1:n
    v = 2*(xk(i)-xk);
    vv = exp(sum(log(abs(v(find(v))))));    
    w(i) = 1./(prod(sign(v(find(v))))*vv);
end
