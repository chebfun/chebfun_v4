function p = bary_general(x,xk,pk,w)   
% P = BARY_GENERAL(X,XK,PK,W) interpolates the values PK at nodes XK in the
% point X using the barycentric weights W. 
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

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
