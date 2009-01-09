function pass = ceiltest

% Rodrigo Platte

splitting on

f1 = chebfun(@(x) ceil(x), -10:2); % Prescribed brkpoints
f2 = chebfun(@(x) ceil(x), [-10 2]); 
pass = f1 == f2;