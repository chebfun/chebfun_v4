function pass = cheb2v_ctor
% This tests the chebfun2 constructor for an easy functions.

pass = 1; 

try 
% % Adaptive calls % % 
f = @(x,y) cos(x); f=chebfun2v(f,f); 
g = @(x,y) sin(y); g=chebfun2v(g,g); 
% exact answers. 
plus_exact = @(x,y) cos(x) + sin(y); plus_exact=chebfun2v(plus_exact,plus_exact); 
minus_exact = @(x,y) cos(x) - sin(y); minus_exact=chebfun2v(minus_exact,minus_exact); 
mult_exact = @(x,y) cos(x).*sin(y); mult_exact=chebfun2v(mult_exact,mult_exact); 
pow_exact = @(x,y) cos(x).^sin(y); pow_exact=chebfun2v(pow_exact,pow_exact); 

% % Forming an autonomous system from a second order linear DE. 
% N = chebop(@(t,y) diff(y,2) + sin(t).*y); 
% F = chebfun2v(N); 

catch
    pass = 0 ; 
end
end