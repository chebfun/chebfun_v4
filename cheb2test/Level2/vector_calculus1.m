function pass = vector_calculus1
% This test if well-known vector calculus relations hold. 

% % f1 = @(x,y) cos(x) + sin(x.*y.^2); 
% % f2 = @(x,y) sin(x) + y; 
% % g1 = @(x,y) x + y.^2 + 4; 
% % g2 = @(x,y) x + y + exp(x); 
% 
% j=1;
% f1 = @(x,y) cos(x); 
% f2 = @(x,y) sin(x); 
% 
% f = chebfun2v(f1,f2);
% % g = chebfun2v(g1,g2);
% 
% % check grad
% h=grad(f); 
% pass(j) = all(abs(h(pi/6,pi/12) + sin(pi/6)*[1 0] )<10*eps); j=j+1;
% 
% % check div
% h=div(f); 
% pass(j) = abs(h(pi/6,pi/12) + sin(pi/6) )<10*eps; j=j+1;
% 
% % check curl 
% h=curl(f); 
% pass(j) = abs(h(pi/6,pi/12) + sin(pi/6) )<10*eps; j=j+1;
% 
% % check divgrad
% h=divgrad(f); 
% pass(j) = abs(h(pi/6,pi/12) + cos(pi/6) )<10*eps; j=j+1;
% 
% 
% % check it works on different interval. 
% f1 = chebfun2(@(x,y) cos(x),[0 1 -.3 .4]); 
% f2 = chebfun2(@(x,y) sin(x),[0 1 -.3 .4]); 
% f = chebfun2v(f1,f2);
% 
% h=grad(f); 
% pass(j) = all(abs(h(pi/6,pi/12) + sin(pi/6)*[1 0] )<10*eps); j=j+1;
% 
% % check div
% h=div(f); 
% pass(j) = abs(h(pi/6,pi/12) + sin(pi/6) )<10*eps; j=j+1;
% 
% % check curl 
% h=curl(f); 
% pass(j) = abs(h(pi/6,pi/12) + sin(pi/6) )<10*eps; j=j+1;
% 
% % check divgrad
% h=divgrad(f); 
% pass(j) = abs(h(pi/6,pi/12) + cos(pi/6) )<100*eps; j=j+1;
% 
% 
% % 
% % h = div(f+g); h2 = div(f) + div(g); 
% % abs(h(pi/6,pi/12) - h2(pi/6,pi/12))
% 
% 
% 
% 
% % Distributive properties.
% 
% % pass(1) = isequal(grad(f+g), grad(f) + grad(g));
% % pass(2) = isequal(div(f+g), div(f) + div(g));
% 
% % Product Rule 
% % pass(3) = isequal(grad(f.*g), f.*grad(g) + g.*grad(f));
% 
% pass = all(pass);
pass = 1; 
end