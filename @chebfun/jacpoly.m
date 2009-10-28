function jac = jacpoly(f,a,b)
% JACPOLY   Jacboi polynomial coefficients.
% A = JACPOLY(F,ALPHA,BETA) returns the coefficients such that
% F_1 = a_N P_N(x)+...+a_1 P_1(x)+a_0 P_0(x) where P_N(x) denotes the N-th
% Jacobi polynomial with paramters ALPHA and BETA, and F_1 denotes the first 
% fun of chebfun F.

chebvals = get(f,'vals');
N = length(chebvals)-1;

% Chebyshev points
x = chebpts(N+1);

apb = a + b;

% Jacobi Vandermonde Matrix
P = zeros(N+1,N+1);
P(:,1) = 1;    
P(:,2) = 0.5*(2*(a+1)+(apb+2)*(x-1));    
for k = 2:N
    k2 = 2*k;
    k2apb = k2 + apb;   
    q1 =  k2*(k + apb)*(k2apb - 2);
    q2 = (k2apb - 1)*(a*a - b*b);
    q3 = (k2apb - 2)*(k2apb - 1)*k2apb;
    q4 =  2*(k + a - 1)*(k + b - 1)*k2apb;
    P(:,k+1) = ((q2+q3*x).*P(:,k) - q4*P(:,k-1)) / q1;
end

% Solve the system
jac = P\chebvals(:);
jac = flipud(jac);

return


%   C = COEFFS_DIRECT ( X , FX , ALFA , BETA , GAMA ) computes
%   the interpolation coefficients C such that
%
%       sum( C(k)*P(k,X(k)) , k=1..N ) = FX(i), i = 1..N
%
%   where P(k,x) are the polynomials satisfying the three-term
%   recurrence relation
%
%       ALFA(k-1) * P(k,x) = (x + BETA(k-1)) * P(k-1,x) - GAMA(k-1) * P(k-2,x),
%       P(0,x) = 1, P(1,x) = x.
%

% init some stuff
n = length(x)-1;
fx = chebvals;
x = chebpts(N+1);

ind = horder(x)
% x = x(ind); fx = fx(ind);

tic
% create the vectors \ell
ell = ones(n) * nan; ell(1,1) = 1; w = (x(2) - x(1));
for i=2:n

    % the new w
    w(i) = 1;
    for j=1:i, w(i) = w(i) * (x(i+1) - x(j)); end;

    % the new \ell
    r = w(i) / w(i-1);
    for j=1:i-1, ell(i,j) = -ell(i-1,j) * r / (x(i+1) - x(j)); end;
    ell(i,i) = r / (x(i+1) - x(i));

end;

% for each column...
for i=n+1:-1:2

    % extract the coefficient
    c(i) = ( ell(i-1,1:i-1) * fx(1:i-1) - fx(i) ) ...
        / ( ell(i-1,1:i-1) * P(1:i-1,i) - P(i,i) );
    % disp( [ max(abs(fx(1:i-1)))/ (ell(i-1,1:i-1) * fx(1:i-1)), max(abs(P(1:i-1,i))) / (ell(i-1,1:i-1) * P(1:i-1,i)) ] );

    % update f
    % fx(1:i) = fx(1:i) - c(i) * P(1:i,i);
    fx = fx - c(i) * P(:,i);

    % extract the coefficient
    % c_delta = ( ell(i-1,1:i-1) * fx(1:i-1) - fx(i) ) ...
    %     / ( ell(i-1,1:i-1) * P(1:i-1,i) - P(i,i) );

    % update f
    % fx(1:i) = fx(1:i) - c_delta * P(1:i,i);
    % disp([ i , c(i) , c_delta , ( ell(i-1,1:i-1) * fx(1:i-1) - fx(i) ) / fx(i) ]);
    % c(i) = c(i) + c_delta;

end; % for each column

% last entry of c
c(1) = fx(1) / P(1,1);
fx = fx - c(1) * P(:,1);
c = flipud(c(:));
toc

[jac c]
% jac(end-10:end)
% c(end-10:end)

norm(jac-c,inf)

function ind = horder ( xi )

n = length(xi);
ind = [ 1:n ];

[ dummy , j ] = min( xi ); xi([1,j]) = xi([j,1]); ind([1,j]) = ind([j,1]);
[ dummy , j ] = max( xi(2:end) ); xi([2,j+1]) = xi([j+1,2]); ind([2,j+1]) = ind([j+1,2]);

for i=3:n, p(i) = xi(i) - xi(1); end;

for k=3:n-1
    for i=k:n, p(i) = p(i) * (xi(i) - xi(k-1)); end;
    [ dummy , j ] = max( abs( p(k:end) ) ); j = j + k - 1;
    xi([k,j]) = xi([j,k]); p([k,j]) = p([j,k]);; ind([k,j]) = ind([j,k]);
end;

ind = ind(:);
    
