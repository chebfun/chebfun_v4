function P = jacpoly(N,a,b,d,flag)
%JACPOLY Jacobi polynomials.
%   P = JACPOLY(N,ALPHA,BETA) computes a chebfun of the Jacobi polynomial 
%   of degree N with parameters ALPHA. BETA on the interval [-1,1]. 
%   N can be a vector of integers.
%
%   P = JACPOLY(N,ALPHA,BETA,D) computes the Jacobi polynomials as above,
%   but on the interval given by the domain D, which must be bounded.
%
%   JACPOLY(N,ALPHA,BETA,D,'norm') or JACPOLY(N,ALPHA,BETA,'norm') will 
%   normalise so that P(D(2)) or P(1) = 1;
%
% See also chebfun/legpoly and chebpoly.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

x = chebpts(N+1);

if nargin < 3, error('jacpoly requires at least 3 inputs'); end
if nargin < 4, d = [-1,1]; end
if nargin < 5, flag = 0; end
if isa(d,'char'), flag = d; d = [-1,1]; end
if isa(d,'domain'), d = d.ends; end

apb = a+b;
P = zeros(N+1,N+1);
P(:,1) = 1;    
P(:,2) = 0.5*(2*(a+1) + (apb+2)*(x-1));    
for k = 2:N
    k2 = 2*k;
    k2apb = k2+apb;
    q1 =  k2*(k + apb)*(k2apb - 2);
    q2 = (k2apb - 1)*(a*a - b*b);
    q3 = (k2apb - 2)*(k2apb - 1)*k2apb;
    q4 =  2*(k + a - 1)*(k + b - 1)*k2apb;
    P(:,k+1) = ((q2+q3*x).*P(:,k)-q4*P(:,k-1))/q1;
end

P = chebfun(P(:,N+1),d);
if flag 
    P = P/P(d(2));
end



