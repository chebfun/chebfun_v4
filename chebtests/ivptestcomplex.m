function pass = ivptestcomplex

% Nick Trefethen March 2009
% This routine testss ode45, ode113, ode15s on a complex ode to
% make sure we get the signs right

f = @(x,u) 1i*u;
d = domain(0,1);

y = ode113(f,d,1);
pass1 = abs(y(1)-exp(1i)) < 2e-2;

y = ode45(f,d,1);
pass2 = abs(y(1)-exp(1i)) < 2e-2;

y = ode15s(f,d,1);
pass3 = abs(y(1)-exp(1i)) < 2e-2;

pass = pass1 && pass2 && pass3;


