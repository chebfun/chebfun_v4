function pass = callpref

% Tests for changes in preference in a chebfun call. 
% Rodrigo Platte, May 2009

f = chebfun(@(x) sign(x-0.5), [-2 3], 'splitting', 1, 'minsamples', 5);
pass(1) = f(0) == -1 && f(0.5) == 0 && f(1) == 1 && length(f) == 2;

f = chebfun(@(x) sin(100*x), 'splitting', 1, 'splitdegree', 32);
pass(2) = true;
for k = 1:numel(f.funs)
    pass(2) = pass(2) && f.funs(k).n <32;
end