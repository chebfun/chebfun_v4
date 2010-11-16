function pass = systemsolve2

% Test solution of a 2x2 system
% TAD

d=domain(-1,1);
D=diff(d);
I=eye(d);
Z=zeros(d);
A=[D+I 2*I;D-I D];
x=d(:);
f=[ exp(x) chebfun(1,d) ];
A.lbc = [I+D Z];
A.rbc = [Z D];
u = A\f;

u1 = u(:,1); u2 = u(:,2);
pass(1) = norm( diff(u1)+u1+2*u2-exp(x)) < 1e4*chebfunpref('eps');
pass(2) = norm( diff(u1)-u1+diff(u2)-1 ) < 1e4*chebfunpref('eps');

f(0,:) = f(0,:);
u = A\f;
u1 = u(:,1); u2 = u(:,2);

err1 = diff(u1)+u1+2*u2-exp(x);
err2 = diff(u1)-u1+diff(u2)-1;
err1.imps = 0*err1.imps;
err2.imps = 0*err2.imps;

pass(3) = norm( err1 ) < 1e4*chebfunpref('eps');
pass(4) = norm( err2 ) < 1e4*chebfunpref('eps');
