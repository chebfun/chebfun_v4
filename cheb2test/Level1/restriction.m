function pass = restriction
% This script checks the surface area script and the restricting a
% function. 
tol  = chebfun2pref('eps');
j = 1; 
% Simple example. 
%f = @(x,y) exp(-10*(x.^2+y.^2));
%g = chebfun2(f); 
%val = surfacearea(g,chebfun(@(t) exp(1i*t),[0,2*pi])); % Should be 2*pi.

%pass(1) = (abs(val - 2*pi) < 100*tol); 

% Restricting a chebfun2 to a point. 
f = @(x,y) exp(-10*(x.^2+y.^2));
g = chebfun2(f); 
val = g{0,0,0,0};  % should be f(0,0); 
pass(j) = (abs(val - f(0,0)) < 100*tol); j=j+1; 

% Restricting a chebfun2 to a chebfun.
f = @(x,y) exp(-10*(x.^2+y.^2));
g = chebfun2(f); 
val = restrict(g,chebfun(@(t) t + 1e-18*1i));  % should be f(x,1e-18); 
pass(j) = (norm(val - chebfun(@(x) f(x,1e-18))) < 100*tol);j=j+1;  

% Using subrefs for restricting
f = @(x,y) exp(-10*(x.^2+y.^2));g = chebfun2(f); 
ref.type='()'; ref.subs={pi/6 ':'}; 
val = subsref(g,ref); exact = chebfun(@(y) f(pi/6,y));
pass(j) = (norm(val - exact) < 100*tol); j=j+1; 

if all(pass) 
    pass = 1; 
end
end