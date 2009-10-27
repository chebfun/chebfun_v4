function P = jacpoly(N,a,b,flag)

x = chebpts(N+1);

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

P = chebfun(P(:,N+1));
if nargin > 3
    P = P/P(1);
end



