function pass = lntAD
% lntAD.m - some AD tests
%           Nick Trefethen, 5 November 2009

[d,x] = domain([1 3]);
one = chebfun(1,d);
y = 2*x;
g = y.^2;
h = diff(g);
pass(1) = h(2)==16;

dgdx = diff(g,x);
dgdx1 = dgdx*one; 
pass(2) = dgdx1(2)==16;

dhdy = diff(h,y);
q = dhdy*one; 
w = dhdy*x;  
pass(3) = q(2)==4;
pass(4) = w(2)==16;