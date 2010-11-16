function pass = systemsolve1

% Test 2x2 system (sin/cos)
% TAD

tol = chebfunpref('eps');

d=domain(-pi,pi);
D=diff(d);
I=eye(d);
Z=zeros(d);
A=[I -D; D I];
x=d(:);
f=[ 0*x 0*x ];
A.lbc = {[I Z],-1};
A.rbc = [Z I];
u = A\f;

u1 = u(:,1); u2 = u(:,2);
pass(1) = norm( u1 - cos(x),inf) < 100*tol;
pass(2) = norm( u2 - sin(x),inf) < 100*tol;

f(0,1) = f(0,1);
u = A\f;

u1 = u(:,1); u2 = u(:,2);
pass(3) = norm( u1 - cos(x),inf) < 2000*tol;
pass(4) = norm( u2 - sin(x),inf) < 2000*tol;

