%% Mathieu functions
% Toby Driscoll, 31 March 2008

%% Periodic
q = 25;
d = domain(-pi,pi);
c = chebfun('cos(2*x)',d);
A = diff(d,2) - 2*q*diag(c);
A.bc = 'periodic';
[V,L] = eigs(A,12);
for j = 1:6
  subplot(3,2,j)
  plot(V{j})
  title(num2str(L(j,j)))
end

%% Mathieu sine and cosine
d = domain(0,12);
x = chebfun('x',d);
a = 2;  q = 6;
A = diff(d,2) + (a - 2*q*diag(cos(2*x)));
A.lbc(1) = 0;
A.lbc(2) = {diff(d),1};
S = A\chebfun(0,d);
A.lbc(1) = {diff(d),0};
A.lbc(2) = 1;
C = A\chebfun(0,d);

%% Sine and cosine again, by integration (more accurate, apparently)
d = domain(0,12);
x = chebfun('x',d);
a = 2;  q = 6;
r = a - 2*q*cos(2*x);
A = eye(d) + diag(r)*cumsum(d,2);
Cxx = A\(-r);
C = 1 + cumsum(cumsum(Cxx));
Sxx = A\( -x.*r );
S = cumsum( 1+cumsum(Sxx) );
S = S - S(0);