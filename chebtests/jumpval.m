function pass = jumpval

% Rodrigo Platte

f = chebfun('sign(x-1)',[0 2]);
pass = f(1)==0;