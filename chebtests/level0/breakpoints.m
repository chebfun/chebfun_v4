function pass = breakpoints
% Check if splitting works, with or without breakpoints.
% Rodrigo Platte

splitting on

f=chebfun(@(x) ceil(x-.1), [0 1 2]);
pass(1) = length(f) == 4;

f=chebfun(@(x) ceil(x-.1));
pass(2) = length(f) == 3;


