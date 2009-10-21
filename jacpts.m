function [x,w] = jacpts(n,alpha,beta,varargin)
%JACPTS  Jacobi points
%  JACPTS(N) returns the roots of the Jacobi polynmial with parameters ALPHA
%  and BETA (which must both be greater than or equal -1).

if alpha <= -1 || beta <= -1,
    error('CHEBFUN:jacpts:SizeAB','alpha and beta must be greater than -1')
end
a = alpha; b = beta;

% defaults
interval = [-1,1];
method = 'default';

% check inputs
if nargin > 3
    if isa(varargin{1},'double') && length(varargin{1}) == 2, interval = varargin{1}; end
    if isa(varargin{1},'char'), method = varargin{1}; end
    if length(varargin) == 2,
        if isa(varargin{2},'double') && length(varargin{2}) == 2, interval = varargin{2}; end
        if isa(varargin{2},'char'), method = varargin{2}; end
    end
end

if abs(alpha)>.5 || abs(beta) > .5
    % FORCING TO USE GW AT THE MOMENT AS FAST ISN'T WORKING IN THIS CASE
    method = 'GW';
end    

if alpha && beta
    % FORCING TO USE GW AT THE MOMENT AS FAST ISN'T WORKING IN THIS CASE
    method = 'GW';
end

% decide to use GW or FAST
if (n < 128 || strcmpi(method,'GW')) && ~strcmpi(method,'fast') || abs(a)>.5 || abs(b) > .5 
    ab = a + b;
    ii = (2:n-1)';
    abi = 2*ii + ab;
    aa = [(b - a)/(2 + ab) ; (b^2 - a^2)./((abi - 2).*abi) ; (b^2 - a^2)./((2*n - 2+ab).*(2*n+ab))];
    bb = [2*sqrt( (1 + a)*(1 + b)/(ab + 3))/(ab + 2) ; 
        2*sqrt(ii.*(ii + a).*(ii + b).*(ii + ab)./(abi.^2 - 1))./abi];
    TT = diag(bb,1) + diag(aa) + diag(bb,-1); % Jacobi matrix
    [v x] = eig( TT );                        % eigenvalue decomposition
    x = diag(x);                              % Jacobi points
    w = v(1,:).^2*( 2^(ab + 1) * gamma(a + 1) * gamma(b + 1) / gamma(2 + ab) ); %weights

else   % Fast, see [2]
   [x ders] = alg0_Jac(n,a,b);                % nodes and P_n'(x)
   w = 2^(a+b+1)./((1-x.^2).*ders.^2)';       % weights
   
end

% rescale to arbitrary interval
a = interval(1); b = interval(2);
x = .5*( (x+1)*b - (x-1)*a);
w = .5*(b-a)*w;

function [roots ders] = alg0_Jac(n,a,b)
if abs(a)<=.5 && abs(b)<=.5 % use asymptotic formula
    r = ceil(n/2); % Choose a root near the middle
    C = (2*r+a-.5)*pi/(2*n+a+b+1);
    T = C + 1/(2*n+a+b+1)^2*((.25-a^2)*cot(.5*C)-(.25-b^2)*tan(.5*C));
    x1 = cos(T);
    
    % Make accurate using Newton
    for k = 1:10
        [u up] = eval_Jac(x1,n,a,b);
        x1 = x1 - u/up;
    end
    [u up] = eval_Jac(x1,n,a,b);

    [rootsl dersl] = alg1_Jac_as(n,x1,up,a,b,1); % Get roots to the left
    if a ~= b 
        [rootsr dersr] = alg1_Jac_as(n,x1,up,a,b,0); % To the right
    else
        rootsr = -rootsl(2:end); % Use symmetry.
        dersr = dersl(2:end);
    end
    roots = [rootsl(end:-1:2) ; rootsr];
    ders = [dersl(end:-1:2) dersr].';
    
    
else
    % this one needs more thinking !!!
    [x1 up] = alg3_Jac(n,0,a,b); 
    [roots ders] = alg1_Jac(n,x1,up,a,b);
end


% ---------------------------------------------------------------------

function [roots ders] = alg1_Jac(n,roots,ders,a,b)
N = ceil(n/2);

ab = a + b;

m = 30; % number of terms in Taylor expansion
u = zeros(1,m+1); up = zeros(1,m+1);
for j = 1:N
    x = roots(j);
    h = rk2_Jac(pi/2,-pi/2,x,n,a,b) - x;
%     h = rk2_Jac(-pi/2,pi/2,x,n,a,b) - x;

    % scaling
    M = 1/h;

    % recurrence relation  (scaled)
    u(1) = 0;   u(2) = ders(j)/M;  up(1) = u(2); up(m+1) = 0;    
    for k = 0:m-2
        u(k+3) = ((x*(2*k+ab+2)+a-b)*u(k+2)/M + ...
            (k*(k+ab+1)-n*(n+ab+1))*u(k+1)/M^2/(k+1))./((1-x.^2)*(k+2));
        up(k+2) = (k+2)*u(k+3)*M;
    end
    
    % flip for more accuracy in inner product calculation
    u = u(m+1:-1:1);
    up = up(m+1:-1:1);
    
    hh = [ones(m,1) ; M];
    step = inf;
    l = 0;
    % Newton iteration
    while (abs(step) > eps) && (l < 10)
        l = l + 1;
        step = (u*hh)/(up*hh);
        h = h - step;
        hh = [M;cumprod(M*h+zeros(m,1))]; % powers of h (This is the fastest way!)
        hh = hh(end:-1:1);
    end
        
    % update
    roots(j+1,1) = x + h;
    ders(j+1,1) = up*hh;   
end

% -------------------------------------------------------------------------

function [roots ders] = alg1_Jac_as(n,x1,ders,a,b,flag) % if |a|<=.5 && |b|<=.5 use asymptotic formula
ab = a + b;

% Approximate roots via asymptotic formula
nx1 = ceil(n/2);
if flag, r = (nx1+1):n; else r = (nx1-1):-1:1; end
C = (2*r+a-.5)*pi/(2*n+ab+1);
T = C + 1/(2*n+a+b+1)^2*((.25-a^2)*cot(.5*C)-(.25-b^2)*tan(.5*C));
roots = [x1 ; cos(T).'];

m = 30; % number of terms in Taylor expansion
u = zeros(1,m+1); up = zeros(1,m+1);
for j = 1:length(r)
    x = roots(j); % previous root
    
    % initial approx (via asymptotic foruma)
    h = roots(j+1) - x;
           
    % scaling
    M = 1/h;

    % recurrence relation for Jacobi polynomials (scaled)
    u(1) = 0;   u(2) = ders(j)/M;  up(1) = u(2); up(m+1) = 0;    
    for k = 0:m-2
        u(k+3) = ((x*(2*k+ab+2)+a-b)*u(k+2)/M + ...
            (k*(k+ab+1)-n*(n+ab+1))*u(k+1)/M^2/(k+1))./((1-x.^2)*(k+2));
        up(k+2) = (k+2)*u(k+3)*M;
    end
    
    % flip for more accuracy in inner product calculation
    u = u(m+1:-1:1);
    up = up(m+1:-1:1);
    
    hh = [ones(m,1) ; M];
    step = inf;
    l = 0;
    % Newton iteration
    while (abs(step) > eps) && (l < 10)
        l = l + 1;
        step = (u*hh)/(up*hh);
        h = h - step;
        hh = [M;cumprod(M*h+zeros(m,1))]; % powers of h (This is the fastest way!)
        hh = hh(end:-1:1);
    end

    % update
    roots(j+1) = x + h;
    ders(j+1) = up*hh;    
end

% ---------------------------------------------------------------------

function [x1 d1] = alg3_Jac(n,xs,a,b)
[u up] = eval_Jac(xs,n,a,b);
theta = atan((1-xs.^2)*up/sqrt(n*(n+a+b+1)*(1-xs.^2))/u);
x1 = rk2_Jac(theta,-pi/2,xs,n,a,b);

for k = 1:10
    [u up] = eval_Jac(x1,n,a,b);
    x1 = x1 - u/up;
end

[u1 d1] = eval_Jac(x1,n,a,b);

% -------------------------------------------------------------------------

function [P Pp] = eval_Jac(x,n,a,b)
ab = a + b;

P = .5*(a-b+(ab+2)*x);  Pm1 = 1; 
Pp = .5*(ab+2);         Ppm1 = 0; 

if n == 0;
    P = Pm1; Pp = Ppm1;
end

for k = 1:n-1
    A = 2*(k+1)*(k+ab+1)*(2*k+ab);
    B = (2*k+ab+1)*(a^2-b^2);
    C = prod(2*k+ab+[0:2]');
    D = 2*(k+a)*(k+b)*(2*k+ab+2);
    
    Pa1 = ( (B+C*x).*P - D*Pm1 ) / A;
    Ppa1 = ( (B+C*x).*Pp + C*P - D*Ppm1 ) / A;
    
    Pm1 = P; P = Pa1;  Ppm1 =  Pp; Pp = Ppa1;
end

% -------------------------------------------------------------------------

function x = rk2_Jac(t,tn,x,n,a,b)
ab = a + b;
m = 10; h = (tn-t)/m;
for j = 1:m
    f1 = (1-x.^2);
    k1 = -h*f1./(sqrt(n*(n+ab+1)*f1) + 0.25*(2*x+b-a-(ab+2)*(x-1)).*sin(2*t));
    t = t+h;  f2 = (1-(x+k1).^2);
    k2 = -h*f2./(sqrt(n*(n+ab+1)*f2) + 0.25*(2*(x+k1)+b-a-(ab+2)*(x+k1-1)).*sin(2*t));
    x = x+.5*real(k1+k2);
end


