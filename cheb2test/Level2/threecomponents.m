function pass = threecomponents 
%% 
% A chebfun2v test for checking that chebfun2v objects with three 
% components is working correctly. 

%% Testing chebfun2v objects with three components. 

tol = chebfun2pref('eps'); j = 1; 

%% Different calls to the constructor. 
f = chebfun2(@(x,y) x ); 
F = chebfun2v(f,f,f); % from chebfun2 objects. 
F = chebfun2v(@(x,y) x, @(x,y) x, @(x,y) x); % handles. 
F = chebfun2v(@(x,y) x,'x+0*y',f); %mixture


%% With domains. 
d = [-1 1 -1 1];
f = chebfun2(@(x,y) x,d); 
F1 = chebfun2v(f,f,f,d); % from chebfun2 objects. 
F2 = chebfun2v(@(x,y) x, @(x,y) x, @(x,y) x,d); % handles. 
F3 = chebfun2v(@(x,y) x,'x+0*y',f,d); %mixture

% Are they the same chebfun2v objects?
pass(j) = ( norm(F1-F2) < tol ) ; j = j+1; 
pass(j) = ( norm(F2-F3) < tol ) ; j = j+1; 


%% Plus chebfun2v objects. 

G = chebfun2v(f,2*f,3*f); 
H = F + G; 
pass(j) = ( norm( H(1,1) - [2 3 4]' )  < tol ); j = j + 1; 
H = G + 1; 
pass(j) = ( norm( H(pi/6,1) - pi/6*[1 2 3]' -1 ) <tol ); j = j + 1; 
H = G + [1 2 3]; 
pass(j) = ( norm( H(pi/6,1) - pi/6*[1 2 3]' -[1 2 3]' ) <tol ); j = j + 1; 

% in reverse
H = 1+ G; 
pass(j) = ( norm( H(pi/6,1) - pi/6*[1 2 3]' -1 ) <tol ); j = j + 1; 
H = [1 2 3] + G; 
pass(j) = ( norm( H(pi/6,1) - pi/6*[1 2 3]' -[1 2 3]' ) <tol ); j = j + 1; 

%% .* chebfun2v objects. 
G = chebfun2v(f,2*f,3*f); 
H = G.*1; 
pass(j) = ( norm( H(pi/6,1) - G(pi/6,1) ) <tol ); j = j + 1; 
H = G.*[1 2 3]'; 
pass(j) = ( norm( H(pi/6,1) -  pi/6*[1 4 9]') <tol ); j = j + 1; 

% in reverse
H = 1.*G; 
pass(j) = ( norm( H(pi/6,1) - G(pi/6,1) ) <tol ); j = j + 1; 
H = [1 2 3]'.*G; 
pass(j) = ( norm( H(pi/6,1) -  pi/6*[1 4 9]') <tol ); j = j + 1;


%% * chebfun2v objects. 
G = chebfun2v(f,2*f,3*f); 
H = G*1; 
pass(j) = ( norm( H(pi/6,1) - G(pi/6,1) ) <tol ); j = j + 1; 
H = G'*[1 2 3]';   % inner product
pass(j) = ( norm( H - (f+4*f+9*f)) <tol ); j = j + 1; 

% in reverse
H = 1*G; 
pass(j) = ( norm( H(pi/6,1) - G(pi/6,1) ) <tol ); j = j + 1; 
try 
    H = [1 2 3]'*G;  % this should fail .
catch
    pass(j) = 0 ; j=j+1; 
end

%% Vector calculus identities
f = chebfun2(@(x,y) sin(x.*y)); 

pass(j) = ( norm(curl( F + G ) - (curl(F) + curl(G))) < 100*tol); j=j+1; 
pass(j) = ( norm(div( f*G ) - (dot(G,[grad(f);0]) + f.*div(G))) <100*tol); j=j+1; 

pass(j) = ( norm(div(curl(G))) < 10*tol); j = j + 1; 
pass(j) = ( norm(div(grad(f)) - lap(f)) < 10*tol); j = j + 1; 
pass(j) = ( norm(curl(curl(G)) - ([grad(div(G));0] - lap(G))) < 10*tol); j = j + 1; 

if all(pass) 
    pass = 1; 
else
    pass = 0; 
end

end