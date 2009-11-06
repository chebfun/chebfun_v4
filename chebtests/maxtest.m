function pass = maxtest

% Rodrigo Platte
% This used to crash because of double roots in sign.m

z = chebfun('x',[-1 1]);
y=max(abs(z),1-z.^2);
v=max(y,1);

pass(1) = norm(v-1) == 0;

% Toby Driscoll
% Checking out syntax of various forms of the call.
y = max([z -z 0.5],[],2);
pass(2) = (sum(y)==1.25);

tol = chebfunpref('eps');
y = max([sin(2*z) cos(z)]);
pass(3) = (sum(y)-2) < 10*tol;

y = max(z.');
pass(4) = (y==1);

y = max([z.'; -z.'; 0.5]);
pass(5) = (sum(y)==1.25);

