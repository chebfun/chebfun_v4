function pass = dummy1
% Intended to crash!

f = chebfun('cos(20*x)');
f'.*f;
pass = true;


