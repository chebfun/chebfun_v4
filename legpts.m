function [x,w] = legpts(n,method)
%LEGPTS  Legendre points in (-1,1).
%  LEGPTS(N) returns N Legendre points in (-1,1).
%
%  [X,W] = LEGPTS(N) also returns a vector of weights for Gauss quadrature.
%
%  [X,W] = LEGPTS(N,METHOD) allows the user to select which method to use.
%       METHOD = 'GW' will use the traditional Golub-Welsch eigenvalue method,
%       which is best suited for when N is small. METHOD = 'FAST' will use 
%       Rokhlin et al's fast algorithm, which is much faster for large N.
%       By default LEGPTS will use 'GW' when N < 128.
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  'GW' by Nick Trefethen, March 2009 - algorithm adapted from [1].
%  'FAST' by Nick Hale, April 2009 - algorithm adapted from [2].
%
%  Copyright 2009 by The Chebfun Team. 
%
%  References:
%   [1] G. H. Golub and J. A. Welsch, "Calculation of Gauss quadrature
%       rules", Math. Comp. 23:221-230, 1969, 
%   [2] A. Glaser, Xa Liu and V. Rokhlin, "A fast algorithm for the 
%       calculation of the roots of special functions", SIAM Journal  
%       on Scientific Computing", 29(4):1420-1438:, 2007.

if n <= 0
    error('Input should be a positive number');
end

% If no preference is supplied, choose via size
if nargin < 2
    method = 'default';
end

if (n < 128 || strcmpi(method,'GW')) && ~strcmpi(method,'fast') % GW, see [1]
   m = n-1;
   beta = .5./sqrt(1-(2*(1:m)).^(-2));   % 3-term recurrence coeffs
   T = diag(beta,1) + diag(beta,-1);     % Jacobi matrix
   [V,D] = eig(T);                       % eigenvalue decomposition
   x = diag(D); [x,i] = sort(x);         % Legendre points
   w = 2*V(1,i).^2;                      % weights
else                                                            % Fast, see [2]
   [x ders] = alg0_Leg(n);               % nodes and P_n'(x)
   w = 2./((1-x.^2).*ders.^2)';          % weights
end

% -------------------------------------------------------------------------

function [roots ders] = alg0_Leg(n) % driver for 'Fast'.

% Compute coefficients of P_m(0), Pm'(0), m = 0,..,N
Pm2 = 0; Pm1 = 1; Ppm2 = 0; Ppm1 = 0;
for k = 0:n-1
    P = -k*Pm2/(k+1);
    Pp = ((2*k+1)*Pm1-k*Ppm2)/(k+1);
    Pm2 = Pm1; Pm1 = P; Ppm2 = Ppm1; Ppm1 = Pp;
end

roots = zeros(n,1); ders = zeros(n,1);                      % allocate storage
if mod(n,2),roots((n-1)/2) = 0; ders((n+1)/2) = Pp;         % zero is a root
else   [roots(n/2+1) ders(n/2+1)] = alg2_Leg(P,n); end      % find first root

[roots ders] = alg1_Leg(roots,ders); % compute roots and derivatives

% -------------------------------------------------------------------------

function [roots ders] = alg1_Leg(roots,ders) % main algorithm for 'Fast'
n = length(roots);
if mod(n,2), N = (n-1)/2; s = 1;
else N = n/2; s = 0; end

m = 30; % number of terms in Taylor expansion
u = zeros(1,m+1); up = zeros(1,m);
for j = N+1:n-1
    x = roots(j);

    % advance ODE via Runge-Kutta for initial approx
    % h = x_new - x_old
    h = rk2_Leg(pi/2,-pi/2,x,n) - x;
    
    % recurrence relation for Legendre polynomials
    u(1) = 0;   u(2) = ders(j);  up(1) = u(2);
    for k = 0:m-2
        u(k+3) = (2*x*(k+1)*u(k+2)+(k*(k+1)-n*(n+1))*u(k+1)/(k+1))./((1-x.^2)*(k+2));
        up(k+2) = (k+2)*u(k+3);
    end
   
    % remove infs
    u(isinf(u)) = 0;
    up(isinf(up)) = 0;
    
    % Newton iteration
    for l = 1:5
        hh = [1;cumprod(h*ones(m,1))]; % powers of h for Taylor series
        h = h - (u*hh)/(up*hh(1:m));
    end
    
    % update
    roots(j+1) = x + h;
    ders(j+1) = up*[1;cumprod(h*ones(m-1,1))];    
end

% nodes are symmetric
roots(1:N+s) = -roots(n:-1:N+1);
ders(1:N+s) = ders(n:-1:N+1);

% -------------------------------------------------------------------------

function [x1 d1] = alg2_Leg(Pn0,n) % find the first root (note of P_n'(0)==0)
% advance ODE via Runge-Kutta for initial approx
x1 = rk2_Leg(0,-pi/2,0,n);

m = 30; % number of terms in Taylor expansion

% recurrence relation for Legendre polynomials
u = zeros(1,m+1); up = zeros(1,m);
u(1) = Pn0;   u(2) = 0; 
for k = 0:2:m-2
    u(k+3) = (k*(k+1)-n*(n+1))*u(k+1)/((k+1)*(k+2)); 
    up(k+2) = (k+2)*u(k+3);
end

% Newton iteration
for l = 1:5
    xk = [1;cumprod(x1*ones(m,1))]; % powers of xk for Taylor series
    x1 = x1 - (u*xk)./(up*xk(1:m));
end
d1 = up*[1;cumprod(x1*ones(m-1,1))]; % P_n'(x1)

% -------------------------------------------------------------------------

function x = rk2_Leg(t,tn,x,n) % Runge-Kutta for Legendre Equation
m = 10; h = (tn-t)/m;
for j = 1:m
    f1 = (1-x.^2);
    k1 = -h*sqrt(f1)./(sqrt(n*(n+1)) - 0.5*x.*sin(2*t));
    t = t+h;  f2 = (1-(x+k1).^2);
    k2 = -h*sqrt(f2)./(sqrt(n*(n+1)) - 0.5*(x+k1).*sin(2*t));   
    x = x+.5*(k1+k2);
end
