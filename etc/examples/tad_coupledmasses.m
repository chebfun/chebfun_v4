% Coupled masses on springs, as a chebop system

[d,x] = domain(0,20);
m1 = 1;  m2 = 2;         % masses
k1 = 8;  k12 = 4;       % springs (wall, coupling)
c = 0.2;                 % damping

D = diff(d);  I = eye(d);  Z = zeros(d);
A = [ m1*D^2+c*D+(k1+k12)*I, -k12*I; 
      -k12*I, m2*D^2+c*D+k12*I ];
A.lbc(1) = { [I Z], -1 };   % pull x1 left
A.lbc(2) = { [Z I],  1 };   % pull x2 right
A.lbc(3) = [D Z];           % x1 at rest
A.lbc(4) = [Z D];           % x2 at rest

u = A\[0*x 0*x];
subplot(1,2,1), plot(u)
subplot(1,2,2), plot(u(:,1),u(:,2))
