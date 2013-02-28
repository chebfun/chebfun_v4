function pass = ctor_test
% This tests the chebfun2 constructor for an easy functions.

pass = 1; 
f = @(x,y) cos(x) + sin(x.*y);  % simple function. 
fstr = 'cos(x) + sin(x.*y)'; % string version.

try 
% % Adaptive calls % % 
f = @(x,y) cos(x); f=chebfun2(f); 
g = @(x,y) sin(y); g=chebfun2(g); 
% exact answers. 
plus_exact = @(x,y) cos(x) + sin(y); plus_exact=chebfun2(plus_exact); 
minus_exact = @(x,y) cos(x) - sin(y); minus_exact=chebfun2(minus_exact); 
mult_exact = @(x,y) cos(x).*sin(y); mult_exact=chebfun2(mult_exact); 
pow_exact = @(x,y) cos(x).^sin(y); pow_exact=chebfun2(pow_exact); 

catch
    pass = 0 ; 
end
end