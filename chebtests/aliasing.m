function pass = aliasing

% Tests for aliasing. Rodrigo Platte, May 2009.

p1 = chebfun(@(x) cos(50*acos(x)), 'sampletest', 1);
p2 = chebpoly(50,[-1,1]);
pass(1) = norm(p1-p2) < chebfunpref('eps')*100;

f = chebfun(@(x) sin(50*x).*exp(-x.^2), [-10,10],'sampletest',1);
pass(2) = length(f) > 600;

