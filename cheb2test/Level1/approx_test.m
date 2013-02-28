function pass = approx_test
% list of functions to approximate. 

j=1; tol = chebfun2pref('eps');

% Mohsin's bugs. 
f = @(x,y) exp(pi*(x+y)); 
x=.995; y=.99; 
g = chebfun2(f); 
pass(j) = (abs(f(x,y)-g(x,y))<1000*tol); j=j+1; 

% composing the same function. 
x = chebfun2(@(x,y)x); y = chebfun2(@(x,y)y); 
f = exp(pi*(x+y)); 
x=.995; y=.99;
pass(j) = (abs(f(x,y)-g(x,y))<1e4*tol); j=j+1; 


% Nick T's function 
f = @(x,y) exp(-100*( x.^2 - x.*y + 2*y.^2 - 1/2).^2);
g = chebfun2(f);
twonorm = 0.545563608722019;
pass(j) = (abs(norm(g)-twonorm)<2*tol); j=j+1; 

x=.995; y=.99;
pass(j) = (abs(f(x,y)-g(x,y))<tol); j=j+1; 


f = chebfun2(@(x,y) exp(3*(cos(x-.1)+cos(y-.2))));
pass(j) = (abs(f(.1,.2) - exp(6))<1e4*tol); j=j+1; 


% f = @(x,y) exp(sin(50*x)) + sin(60*exp(y)) + sin(70*sin(x)) + sin(sin(80*y)) -...
%     sin(10*(x+y)) + (x.^2+y.^2)./4; 
% g = chebfun2(f);
% Y = min2(g); exact = -3.306868647475237;
% pass(j) = (abs(exact - Y)<2e3*tol); j=j+1;


% x = chebfun2(@(x,y) x); y = chebfun2(@(x,y) y);
% f = sin(2*pi*x.^2+y.^2);
% pass(j) = (abs(1 - max2(f))<100*tol); j=j+1;
% pass(j) = (abs(1+min2(f))<100*tol); j=j+1;

pass = all(pass); 
end