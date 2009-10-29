function jac = jacpoly(f,a,b)
% JACPOLY   Jacboi polynomial coefficients.
% A = JACPOLY(F,ALPHA,BETA) returns the coefficients such that
% F = A(1) P_N(x) + ... + A(N) P_1(x) + A(N+1) P_0(x) where P_N(x) denotes 
% the N-th Jacobi polynomial with parameters ALPHA and BETA.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2009 by The Chebfun Team. 

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
jac = flipud(jac).';