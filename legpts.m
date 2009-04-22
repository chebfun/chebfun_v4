function [x,w] = legpts(n,method)
% X = LEGPTS(N)  N Chebyshev points in (-1,1)
%
% [X,W] = LEGPTS(N)  also includes vector of weights for Gauss quadrature
%
% [X,W] = LEGPTS(N,METHOD) choose which method to use to compute nodes and
%       weights. METHOD = 'GW' will use the Golub-Welsh whereas 'FAST' will
%       use Rohklin et al's fast algorithm [1].
%
% GW by Nick Trefethen, March 2009.
% FAST by Nick Hale, April 2009.
% Copyright 2002-2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/
%
% [1]  G,L&R, "A fast algorithm for ...", SISC, 29(4):1420–1438, 2007.


if n<=0
    error('Input should be a positive number');
end

% If no preference is supplied, choose via size
if nargin < 2
    method = 'default';
end

if (n < 128 || strcmpi(method,'GW')) && ~strcmpi(method,'fast') % Golub-Welsh
   m = n-1;
   beta = .5./sqrt(1-(2*(1:m)).^(-2));   % 3-term recurrence coeffs
   T = diag(beta,1) + diag(beta,-1);     % Jacobi matrix
   [V,D] = eig(T);                       % eigenvalue decomposition
   x = diag(D); [x,i] = sort(x);         % Legendre points
   w = 2*V(1,i).^2;                      % weights
else                                                            % Fast
   [x ders] = alg0_Leg(n);
   w = 2./((1-x.^2).*ders.^2)';
end

% -------------------------------------------------------------------------

function [roots ders] = alg0_Leg(n)
Pm2 = 0; Pm1 = 1; Ppm2 = 0; Ppm1 = 0;
for k = 0:n-1
    P = -k*Pm2/(k+1);
    Pp = ((2*k+1)*Pm1-k*Ppm2)/(k+1);
    Pm2 = Pm1; Pm1 = P; Ppm2 = Ppm1; Ppm1 = Pp;
end

roots = zeros(n,1); ders = zeros(n,1);
if mod(n,2),roots((n-1)/2) = P; ders((n+1)/2) = Pp;
else   [roots(n/2+1) ders(n/2+1)] = alg2_Leg(P,n); end

[roots ders] = alg1_Leg(roots,ders);

% -------------------------------------------------------------------------

function [roots ders] = alg1_Leg(roots,ders)
n = length(roots);
if mod(n,2), N = (n-1)/2; s = 1;
else N = n/2; s = 0; end

m = 30;
u = zeros(1,m+1); up = zeros(1,m);
for j = N+1:n-1
    x = roots(j);
    h = rk2_Leg(pi/2,-pi/2,x,n) - x;
    
    u(1) = 0;   u(2) = ders(j);  up(1) = u(2);
    for k = 0:m-2
        u(k+3)=(2*x*(k+1)*u(k+2)+(k*(k+1)-n*(n+1))*u(k+1)/(k+1))./((1-x.^2)*(k+2));
        up(k+2) = (k+2)*u(k+3);
    end
    
    for l = 1:5
        hh = [1;cumprod(h*ones(m,1))];
        h = h - (u*hh)/(up*hh(1:m));
    end
    
    roots(j+1) = x + h;
    ders(j+1) = up*[1;cumprod(h*ones(m-1,1))];    
end

roots(1:N+s) = -roots(n:-1:N+1);
ders(1:N+s) = ders(n:-1:N+1);

% -------------------------------------------------------------------------

function [x1 d1] = alg2_Leg(uxe,n)
x1 = rk2_Leg(0,-pi/2,0,n);

m = 30;
u = zeros(1,m+1); up = zeros(1,m);
u(1) = uxe;   u(2) = 0; 
for k = 0:2:m-2
    u(k+3) = (k*(k+1)-n*(n+1))*u(k+1)/((k+1)*(k+2)); 
    up(k+2) = (k+2)*u(k+3);
end

for l = 1:5
    xk = [1;cumprod(x1*ones(m,1))];
    x1 = x1 - (u*xk)./(up*xk(1:m));
end
d1 = up*[1;cumprod(x1*ones(m-1,1))];

% -------------------------------------------------------------------------

function x = rk2_Leg(t,tn,x,n)
m = 10; h = (tn-t)/m;
for j = 1:m
    f1 = (1-x.^2);
    k1 = -h*f1./(sqrt(n*(n+1)*f1) - 0.5*x.*sin(2*t));
    t = t+h;  f2 = (1-(x+k1).^2);
    k2 = -h*f2./(sqrt(n*(n+1)*f2) - 0.5*(x+k1).*sin(2*t));   
    x = x+.5*(k1+k2);
end
