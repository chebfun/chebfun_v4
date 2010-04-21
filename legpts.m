function [x,w,ders] = legpts(n,varargin)
%LEGPTS  Legendre points and Gauss Quadrature Weights.
%  LEGPTS(N) returns N Legendre points X in (-1,1).
%
%  LEGPTS(N,D) scales the nodes and weights for the domain D. D can be
%  either a domain object or a vector with two components. If the interval
%  is infinite, the map is chosen to be the default 'unbounded map' with
%  mappref('parinf') = [1 0] and mappref('adaptinf') = 0.
%
%  [X,W] = LEGPTS(N) also returns a row vector of weights for Gauss quadrature.
%
%  [X,W] = LEGPTS(N,METHOD) allows the user to select which method to use.
%       METHOD = 'GW' will use the traditional Golub-Welsch eigenvalue method,
%       which is best for when N is small. METHOD = 'FAST' will use the
%       Glaser-Liu-Rokhlin fast algorithm, which is much faster for large N.
%       By default LEGPTS uses 'GW' when N < 128.
%
%  See also chebpts and jacpts.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  'GW' by Nick Trefethen, March 2009 - algorithm adapted from [1].
%  'FAST' by Nick Hale, April 2009 - algorithm adapted from [2].
%
%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:
%
%  References:
%   [1] G. H. Golub and J. A. Welsch, "Calculation of Gauss quadrature
%       rules", Math. Comp. 23:221-230, 1969, 
%   [2] A. Glaser, X. Liu and V. Rokhlin, "A fast algorithm for the 
%       calculation of the roots of special functions", SIAM Journal  
%       on Scientific Computing", 29(4):1420-1438:, 2007.

if n <= 0
    error('CHEBFUN:legpts:n','First input should be a positive number.');
end

% Defaults
interval = [-1,1];
method = 'default';

% Check inputs
% Check the inputs
while ~isempty(varargin)
    s = varargin{1}; varargin(1) = [];
    if ischar(s)
        if strcmpi(s,'GW'), method = 'GW';
        elseif strcmpi(s,'fast'), method = 'fast';   
        else error('CHEBFUN:legpts:inputs',['Unrecognised input string.', s]); 
        end
    elseif isa(s,domain), interval = s.ends;
    elseif isa(varargin{2},'double') && length(varargin{2}) == 2, interval = s;
    else error('CHEBFUN:legpts:input','Unrecognised input.');
    end
end

% Decide to use GW or FAST
if (n < 128 || strcmpi(method,'GW')) && ~strcmpi(method,'fast') 
% GW, see [1]
   beta = .5./sqrt(1-(2*(1:n-1)).^(-2)); % 3-term recurrence coeffs
   T = diag(beta,1) + diag(beta,-1);     % Jacobi matrix
   [V,D] = eig(T);                       % Eigenvalue decomposition
   x = diag(D); [x,i] = sort(x);         % Legendre points
   w = 2*V(1,i).^2;                      % Weights
   % Enforce symmetry
   ii = 1:floor(n/2);  x = x(ii);  w = w(ii);
   if mod(n,2)
        x = [x ; 0 ; -flipud(x)];  w = [w  2-sum(2*w) fliplr(w)];
   else
        x = [x ; -flipud(x)];      w = [w fliplr(w)];
   end
else
% Fast, see [2]
   [x ders] = alg0_Leg(n);               % Nodes and P_n'(x)
   w = 2./((1-x.^2).*ders.^2)';          % Weights
end

% Normalise so that sum(w) = 2
w = (2/sum(w))*w;           

% Rescale to arbitrary interval
if ~all(interval == [-1 1])
    if ~any(isinf(interval))
    % Finite interval
        dab = diff(interval);
        x = (x+1)/2*dab + interval(1);
        w = dab*w/2;
    else
    % Infinite interval
        m = maps(fun,{'unbounded'},interval); % use default map
        if nargout > 1
            w = w.*m.der(x.');
        end
        x = m.for(x);
        x([1 end]) = interval([1 end]);
    end
end

% -------------------- Routines for FAST algorithm ------------------------

function [roots ders] = alg0_Leg(n) % Driver for 'Fast'.

% Compute coefficients of P_m(0), m = 0,..,N via recurrence relation.
Pm2 = 0; Pm1 = 1; 
for k = 0:n-1, P = -k*Pm2/(k+1); Pm2 = Pm1; Pm1 = P; end

% Get the first roots and derivative values to initialise.
roots = zeros(n,1); ders = zeros(n,1);                      % Allocate storage
if mod(n,2)                                                 % n is odd
    roots((n-1)/2) = 0;                                     % Zero is a root
    ders((n+1)/2) = n*Pm2;                                  % P'(0)    
else                                                        % n is even
    [roots(n/2+1) ders(n/2+1)] = alg2_Leg(P,n);             % Find first root
end        
[roots ders] = alg1_Leg(roots,ders);          % Other roots and derivatives

% -------------------------------------------------------------------------

function [roots ders] = alg1_Leg(roots,ders)  % Main algorithm for 'Fast'
n = length(roots);
if mod(n,2), N = (n-1)/2; s = 1; else N = n/2; s = 0; end   

% Approximate roots via asymptotic formula.
k = (n-2+s)/2:-1:1; theta = pi*(4*k-1)/(4*n+2);
roots(((n+4-s)/2):end) = (1-(n-1)/(8*n^3)-1/(384*n^4)*(39-28./sin(theta).^2)).*cos(theta);
x = roots(N+1);

% Number of terms in Taylor expansion.
m = 30;

% Storage
hh1 = ones(m+1,1); zz = zeros(m,1); u = zeros(1,m+1); up = zeros(1,m+1);

% Loop over all the roots we want to find (using symmetry).
for j = N+1:n-1
    % Distance to initial approx for next root (from asymptotic foruma).
    h = roots(j+1) - x;

    % Recurrence Taylor coefficients (scaled & incl factorial terms).
    M = 1/h;                           % Scaling
    c1 = 2*x/M; c2 = 1./(1-x^2);       % Some constants
    % Note, terms are flipped for more accuracy in inner product calculation.
    u([m+1 m]) = [0 ders(j)/M];  up(m+1) = u(m);
    for k = 0:m-2
        up(m-k) = (c1*(k+1)*u(m-k)+(k-n*(n+1)/(k+1))*u(m-k+1)/M^2)*c2;
        u(m-(k+1)) = up(m-k)/(k+2);
    end
    up(1) = 0;   
           
    % Newton iteration
    hh = hh1; step = inf;  l = 0; 
    while (abs(step) > eps) && (l < 10)
        l = l + 1;
        step = (u*hh)/(up*hh)/M;
        h = h - step;        
        Mhzz = (M*h)+zz;
        hh = [1;cumprod(Mhzz)];     % Powers of h (This is the fastest way!)
        hh = hh(end:-1:1);          % Flip for more accuracy in inner product 
    end
      
    % Update
    x = x + h;
    roots(j+1) = x;
    ders(j+1) = M*(up*hh);  
       
end

% Nodes are symmetric.
roots(1:N+s) = -roots(n:-1:N+1);
ders(1:N+s) = ders(n:-1:N+1);

% -------------------------------------------------------------------------

function [x1 d1] = alg2_Leg(Pn0,n) % Find the first root (note P_n'(0)==0)
% Approximate first root via asymptotic formula
k = ceil(n/2); theta = pi*(4*k-1)/(4*n+2);
x1 = (1-(n-1)/(8*n^3)-1/(384*n^4)*(39-28./sin(theta).^2)).*cos(theta);

m = 30; % Number of terms in Taylor expansion.

% Recurrence Taylor coefficients (scaled & incl factorial terms).
M = 1/x1; % Scaling
zz = zeros(m,1); u = [Pn0 zeros(1,m)]; up = zeros(1,m+1); % Allocate storage
for k = 0:2:m-2
    up(k+2) = (k-n*(n+1)/(k+1))*u(k+1)/M^2;
    u(k+3) = up(k+2)/(k+2);
end
% Flip for more accuracy in inner product calculation.
u = u(m+1:-1:1); up = up(m+1:-1:1);

% % Note, terms are flipped for more accuracy in inner product calculation.
% zz = zeros(m,1); u = [zeros(1,m) Pn0]; up = zeros(1,m+1); % Allocate storage
% for k = 0:2:m-2
%     up(m-k) = (k-n*(n+1)/(k+1))*u(m-k+1)/M^2;
%     u(m-(k+1)) = up(m-k)/(k+2);
% end

% Newton iteration
x1k = ones(m+1,1); step = inf; l = 0;
while (abs(step) > eps) && (l < 10)
    l = l + 1;
    step = (u*x1k)/(up*x1k)/M;
    x1 = x1 - step;
    x1k = [1;cumprod(M*x1+zz)]; % Powers of h (This is the fastest way!)
    x1k = x1k(end:-1:1);        % Flip for more accuracy in inner product
end

% Get the derivative at this root, i.e. P'(x1).
d1 = M*(up*x1k);


