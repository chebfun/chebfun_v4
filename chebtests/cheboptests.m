% Test a few things concerning the new chebopbs (i.e.
% with nonlinear as well as linear capabilities.)
%     LNT & TAD 4 Dec. 2009.

function pass = cheboptests

tol = 1e4*chebfunpref('eps');

[d,x,N] = domain(-1,1);
N = chebop(d,@(u)0.01*diff(u,2)+x.*u,@(u)u,@(u)u-1);
u = N\0; plot(u,'m')

pass(1) = (abs(u(.5)-0.0345) < .1);

N = diff(d,2) & 'neumann';
initial = 1-x.^6;
final = expm(.1*N)*initial;
plot(initial,'b',final,'r')

pass(2) = (abs(sum(initial-final))<tol);

e = eigs(N);
pass(3) = (abs(e(3)+9.869604)<.1);


[d,x,N] = domain(-1,1);

N.op = @(u) diff(u,3) + sinh(u);
N.lbc = {@(u) u+1,@(u) diff(u)};
N.rbc = 1;
N.guess = x;
u = N\0;
plot(u,'.-')

