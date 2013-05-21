function pass = chebfun2v_roots
% Check that the marching squares and Bezoutian agree with each other. 
% YN, VN & AT, April 2013. Uncomment tests if harder tests should be executed.
%%
tol = 100*chebfun2pref('eps'); 
j = 1; 

%% 
f = chebfun2(@(x,y) 144*(x.^4+y.^4)-225*(x.^2+y.^2) + 350*x.^2.*y.^2+81); 
g = chebfun2(@(x,y) y-x.^6); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1; 

%% 
f = chebfun2(@(x,y)(y.^2-x.^3).*((y-0.7).^2-(x-0.3).^3).*((y+0.2).^2-(x+0.8).^3).*((y+0.2).^2-(x-0.8).^3)); 
g = chebfun2(@(x,y)((y+.4).^3-(x-.4).^2).*((y+.3).^3-(x-.3).^2).*((y-.5).^3-(x+.6).^2).*((y+0.3).^3-(2*x-0.8).^3)); 
r2 = roots([f;g],'resultant'); 
pass(j) = ~( length(r2) - 13 );  j = j + 1;
pass(j) = ( norm(f(r2(:,1),r2(:,2))) < 1e3*tol ); j = j + 1; 
pass(j) = ( norm(g(r2(:,1),r2(:,2))) < 1e3*tol ); j = j + 1;

%%
f = chebfun2(@(x,y)y.^2-x.^3); 
g = chebfun2(@(x,y)(y+.1).^3-(x-.1).^2); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%%
f = chebfun2(@(x,y)cos(10*x.*y)); 
g = chebfun2(@(x,y) x + y.^2); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%%
f = chebfun2(@(x,y)x); 
g = chebfun2(@(x,y) (x-.9999).^2 + y.^2-1); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% Boyd's problem in Chebfun workshop talk.
f = chebfun2(@(x,y)sin(4*(x + y/10 + pi/10))); 
g = chebfun2(@(x,y) cos(2*(x-2*y+pi/7))); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% slow one.
% f = chebfun2(@(x,y)exp(x-2*x.^2-y.^2).*sin(10*(x+y+x.*y.^2))); 
% g = chebfun2(@(x,y)exp(-x+2*y.^2+x.*y.^2).*sin(10*(x-y-2*x.*y.^2))); 
% r1 = roots([f;g]); 
% r2 = roots([f;g]); 
% pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
% pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;
% 
%% another slow one.
% rect = 4*[-1 1 -1 1]; 
% f = chebfun2(@(x,y)2*y.*cos(y.^2).*cos(2*x)-cos(y),rect); 
% g = chebfun2(@(x,y)2*sin(y.^2).*sin(2*x)-sin(x),rect); 
% r1 = roots([f;g]); 
% r2 = roots([f;g]); 
% pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < 10*tol ); j = j + 1; 
% pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < 10*tol ); j = j + 1;


%% (Marching squares fails)
f = chebfun2(@(x,y)((x-.3).^2+2*(y+0.3).^2-1)); 
g = chebfun2(@(x,y)((x-.49).^2+(y+.5).^2-1).*((x+0.5).^2+(y+0.5).^2-1).*((x-1).^2+(y-0.5).^2-1)); 
%r1 = roots([f;g]); 
r2 = roots([f;g],'resultant'); 
pass(j) = ~( length(r2) - 4 ); j = j+1;
pass(j) = ( norm(f(r2(:,1),r2(:,2))) < tol ); j = j + 1; 
pass(j) = ( norm(g(r2(:,1),r2(:,2))) < 1e2*tol ); j = j + 1; 

%% (Marching Squares misses a root)
f = chebfun2(@(x,y)((x-0.1).^2+2*(y-0.1).^2-1).*((x+0.3).^2+2*(y-0.2).^2-1).*((x-0.3).^2+2*(y+0.15).^2-1).*((x-0.13).^2+2*(y+0.15).^2-1)); 
g = chebfun2(@(x,y)(2*(x+0.1).^2+(y+0.1).^2-1).*(2*(x+0.1).^2+(y-0.1).^2-1).*(2*(x-0.3).^2+(y-0.15).^2-1).*((x-0.21).^2+2*(y-0.15).^2-1)); 
% r1 = roots([f;g]); 
r2 = roots([f;g],'resultant'); 
pass(j) = ~( length(r2) - 45 ); j = j+1;
pass(j) = ( norm(f(r2(:,1),r2(:,2))) < tol ); j = j + 1; 
pass(j) = ( norm(g(r2(:,1),r2(:,2))) < tol ); j = j + 1; 

%%
f = chebfun2(@(x,y)sin(3*(x+y))); 
g = chebfun2(@(x,y)sin(3*(x-y))); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% Face and apple example
f = chebfun2(@(x,y)((90000*y.^10 + (-1440000)*y.^9 + (360000*x.^4 + 720000*x.^3 + 504400*x.^2 + 144400*x +...
     9971200).*(y.^8) + ((-4680000)*x.^4 + (-9360000)*x.^3 + (-6412800)*x.^2 + (-1732800).*x +...
     (-39554400)).*(y.^7) + (540000*x.^8 + 2160000*x.^7 + 3817600*x.^6 + 3892800*x.^5 +...
     27577600*x.^4 + 51187200*x.^3 + 34257600*x.^2 + 8952800*x + 100084400).*(y.^6) +...
     ((-5400000)*x.^8 + (-21600000)*x.^7 + (-37598400)*x.^6 + (-37195200)*x.^5 +...
     (-95198400)*x.^4 + (-153604800)*x.^3 + (-100484000)*x.^2 + (-26280800).*x +...
     (-169378400)).*(y.^5) + (360000*x.^12 + 2160000*x.^11 + 6266400*x.^10 + 11532000*x.^9 +...
     34831200*x.^8 + 93892800*x.^7 + 148644800*x.^6 + 141984000*x.^5 + 206976800*x.^4 +...
     275671200*x.^3 + 176534800*x.^2 + 48374000*x + 194042000).*(y.^4) + ((-2520000)*x.^12 +...
     (-15120000)*x.^11 + (-42998400)*x.^10 + (-76392000)*x.^9 + (-128887200)*x.^8 + ...
     (-223516800)*x.^7 + (-300675200)*x.^6 + (-274243200)*x.^5 + (-284547200)*x.^4 + ...
     (-303168000)*x.^3 + (-190283200)*x.^2 + (-57471200).*x + (-147677600)).*(y.^3) +...
     (90000*x.^16 + 720000*x.^15 + 3097600*x.^14 + 9083200*x.^13 + 23934400*x.^12 +...
     58284800*x.^11 + 117148800*x.^10 + 182149600*x.^9 + 241101600*x.^8 + 295968000*x.^7 +...
     320782400*x.^6 + 276224000*x.^5 + 236601600*x.^4 + 200510400*x.^3 + 123359200*x.^2 + ...
     43175600*x + 70248800).*(y.^2) + ((-360000)*x.^16 + (-2880000)*x.^15 + (-11812800)*x.^14 +...
     (-32289600)*x.^13 + (-66043200)*x.^12 + (-107534400)*x.^11 + (-148807200)*x.^10 + (-184672800)*x.^9 + (-205771200)*x.^8 + (-196425600)*x.^7 + (-166587200)*x.^6 + (-135043200)*x.^5 + (-107568800)*x.^4 + (-73394400)*x.^3 + (-44061600)*x.^2 + (-18772000)*x + (-17896000)).*y + (144400*x.^18 + 1299600*x.^17 + 5269600*x.^16 + 12699200*x.^15 + 21632000*x.^14 + 32289600*x.^13 + 48149600*x.^12 + 63997600*x.^11 + 67834400*x.^10 + 61884000*x.^9 + 55708800*x.^8 +...
     45478400*x.^7 + 32775200*x.^6 + 26766400*x.^5 + 21309200*x.^4 + 11185200*x.^3 + 6242400*x.^2 + 3465600*x + 1708800)))); 
g = chebfun2(@(x,y)1e-4*(y.^7 + (-3)*y.^6 + (2*x.^2 + (-1)*x + 2).*y.^5 + (x.^3 + (-6)*x.^2 + x + 2).*y.^4 + ...
     (x.^4 + (-2)*x.^3 + 2*x.^2 + x + (-3)).*y.^3 + (2*x.^5 + (-3)*x.^4 + x.^3 + 10*x.^2 + (-1)*x + 1).*y.^2 + ((-1)*x.^5 + 3*x.^4 + 4*x.^3 + (-12)*x.^2).*y + (x.^7 + (-3)*x.^5 + (-1)*x.^4 + (-4)*x.^3 + 4*x.^2))); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% (slow one)
% f = chebfun2(@(x,y)exp(x-2*x.^2-y.^2).*sin(10*(x+y+x.*y.^2))); 
% g = chebfun2(@(x,y)exp(-x+2*y.^2+x.*y.^2).*sin(10*(x-y-2*x.*y.^2))); 
% r1 = roots([f;g]); 
% r2 = roots([f;g]); 
% pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
% pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%%
rect = 2*[-1 1 -1 1];
f = chebfun2(@(x,y)2*x.*y.*cos(y.^2).*cos(2*x)-cos(x.*y),rect); 
g = chebfun2(@(x,y)2*sin(x.*y.^2).*sin(3*x.*y)-sin(x.*y),rect); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% Marching squares double counts some solutions. 
f = chebfun2(@(x,y)(y - 2*x).*(y+0.5*x)); 
g = chebfun2(@(x,y) x.*(x.^2+y.^2-1)); 
% r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
% pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < 10*sqrt(tol) ); j = j + 1; 
% pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < 10*sqrt(tol) ); j = j + 1;
pass(j) = ( norm(f(r2(:,1),r2(:,2))) < tol ); j = j + 1; 
pass(j) = ( norm(g(r2(:,1),r2(:,2))) < tol ); j = j + 1; 

%%
f = chebfun2(@(x,y)(y - 2*x).*(y+.5*x)); 
g = chebfun2(@(x,y) (x-.0001).*(x.^2+y.^2-1)); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < 10*tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < 100*tol ); j = j + 1;

%%
f = chebfun2(@(x,y)25*x.*y - 12); 
g = chebfun2(@(x,y)x.^2+y.^2-1); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%%
f = chebfun2(@(x,y)(x.^2+y.^2-1).*(x-1.1)); 
g = chebfun2(@(x,y)(25*x.*y-12).*(x-1.1)); 
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% (Marching squares misses some solutions)
f = chebfun2(@(x,y)y.^4 + (-1)*y.^3 + (2*x.^2).*(y.^2) + (3*x.^2).*y + (x.^4)); 
g = @(x,y)y.^10-2*(x.^8).*(y.^2)+4*(x.^4).*y-2; 
g = chebfun2(@(x,y) g(2*x,2*(y+.5)));
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(f(r2(:,1),r2(:,2))) < tol ); j = j + 1; 
pass(j) = ( norm(g(r2(:,1),r2(:,2))) < 1000*tol ); j = j + 1;

%% (Marching squares misses a solution)
a=1e-9; rect = a*[-1 1 -1 1];
f = chebfun2(@(x,y)cos(x.*y/a^2)+sin(3*x.*y/a^2),rect); 
g = chebfun2(@(x,y)cos(y/a)-cos(2*x.*y/a^2),rect);
% r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
% pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
% pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;
pass(j) = ( norm(f(r2(:,1),r2(:,2))) < 1000*tol ); j = j + 1; 
pass(j) = ( norm(g(r2(:,1),r2(:,2))) < 1000*tol ); j = j + 1;

%% (Marching squares misses the roots of the edge)
% f = chebfun2(@(x,y)sin(3*pi*x).*cos(x.*y)); 
% g = chebfun2(@(x,y)sin(3*pi*y).*cos(sin(x.*y))); 
% r2 = roots([f;g]); 
% pass(j) = ( norm(f(r2(:,1),r2(:,2))) < tol ); j = j + 1; 
% pass(j) = ( norm(g(r2(:,1),r2(:,2))) < tol ); j = j + 1;

%%
f = chebfun2(@(x,y)sin(10*x-y/10)); 
g = chebfun2(@(x,y)cos(3*x.*y));
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%%
f = chebfun2(@(x,y)sin(10*x-y/10) + y); 
g = chebfun2(@(x,y)cos(10*y-x/10) - x);
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%%
f = chebfun2(@(x,y)x.^2+y.^2-.9^2); 
g = chebfun2(@(x,y)sin(x.*y));
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%%
f = chebfun2(@(x,y)x.^2+y.^2-.49^2); 
g = chebfun2(@(x,y)(x-.1).*(x.*y-.2));
r1 = roots([f;g],'ms'); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r1(:,1))-sort(r2(:,1))) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r1(:,2))-sort(r2(:,2))) < tol ); j = j + 1;

%% (Marching Squares misses some solution along edge)
f = chebfun2(@(x,y)(x-1).*(cos(x.*y.^2)+2)); 
g = chebfun2(@(x,y)sin(8*pi*y).*(cos(x.*y)+2)); 
r2 = roots([f;g],'resultant'); 
pass(j) = ( norm(sort(r2(:,1))-1) < tol ); j = j + 1; 
pass(j) = ( norm(sort(r2(:,2))-linspace(-1,1,17).') < tol ); j = j + 1;


%%  So many good test problems.  Put into test later.
% p1=@(x,y) (x.^2-1).^2-y.^2.*(3+2.*y); %pretzel
% rr = randn(1,2); p2=@(x,y) y.^2-x.^3+5*rr(1).*x+5*rr(2); %elliptic
% p3=@(x,y) prod(randn(d,1).*x-randn(d,1).*y); %star; origin is highly singular and may cause problems
% p4=@(x,y) (x.^2+y.^2+x.*y).*[y.^2 y 1].*randn(3).*[x.^2;x;1]+[y.^2 y 1].*100.*eps.*randn(3).*[x.^2;x;1]; %perturbation of a given curve; two copies will be close to having a common component
% p5=@(x,y) 1e-7*(((3.*x+3.*y).^5-54.*x.*y).*((3.*x-0.25).^6+(3.*y+0.36).^7-0.1.*(3.*x+3.*y).^8).*(x-y).*(x+y).*x.*y.*((3.*x+3.*y).^4+(3.*x+3.*y).^3+(3.*x-3.*y).^9).*(x-0.5).*(x-1).*(x+0.5).*(x+1).*(y-0.5).*(y-1).*(y+0.5).*(y+1).*(x-y+0.5).*(x-y-0.5).*(x+y-0.5).*(x+y+0.5)); %embarassingly full of singular points
% p5=@(x,y) 1e-4*(((3.*x+3.*y).^5-54.*x.*y).*(x-y).*(x+y).*x.*y.*((3.*x+3.*y).^4+(3.*x+3.*y).^3+(3.*x-3.*y).^9).*(x-0.5).*(x-1).*(x+0.5).*(x+1).*(y-0.5).*(y-1).*(y+0.5).*(y+1).*(x-y+0.5).*(x-y-0.5).*(x+y-0.5).*(x+y+0.5)); %embarassingly full of singular points
% cp=-cos([0:d]*pi/d);p6=@(x,y) prod(x-cp).*prod(y-cp); %grid such that each chebyshev point is singular
% a=1/4;p7=@(x,y) (x.^2 + y.^2 - 2.*a.*x).^2  - 4*a^2.*(x.^2 + y.^2); %cardioid
% p8=@(x,y) (y.^2-x.^2).*(x-1).*(2.*x-3)-4.*(x.^2+y.^2-2.*x).^2; %Ampersand
% p9=@(x,y) (x.^2-1/9).*(x-1/3).^2+(y.^2-1/9).^2; %two cusps
% p10=@(x,y) x.^4+2.*x.^2.*y.^2+y.^4-x.^3-3.*x.*y.^2; %Irish curve
% p11=@(x,y) (x.^2+y.^2).^3-4.*x.^2.*y.^2; %lucky Irish curve
% p12=@(x,y) (-6.*x+9.*x.^2+9.*y.^2).^2-9.*x.^2-9.*y.^2; %trisectrix
% p13=@(x,y) x.^6+y.^6-x.^2; %butterfly
% p14=@(x,y) x.^3.*y+y.^3+x; %Klein curve
% r = rand; 
% p15=@(x,y) ((x-0.5).^2+y.^2).*((x+0.5).^2+y.^2)-r; %Cassini oval
% p16=@(x,y) (16*x.^2+16*y.^2-4).^3-1728.*y.^2; %nephroid
% p17=@(x,y) (x.^2+y.^2).^2-2.*x.^2-2.*y.^2; %Bernoulli lemniscate
% p18=@(x,y) (16*(x.^2)+16*(y.^2)).^2+288.*(x.^2+y.^2)-8.*(64*(x.^3)-192*x.*(y.^2))-27; %deltoid
% p19=@(x,y) (y.^2).*(y.^2-0.5)-x.^2.*(x.^2-1); %devil's curve
% a=0:1/10:1; 
% p20a=@(x,y) prod(4.*y.^2.*(4.*y.^2-a.^2)-4.*x.^2.*(4.*x.^2-1)); %diabolic combination of devil's curves
% p20b=@(x,y) (4*(y.^2).*(4*(y.^2)-a(1))-4.*(x.^2).*(4*(x.^2)-1))... 
% .*(4*(y.^2).*(4*(y.^2)-a(2))-4.*(x.^2).*(4*(x.^2)-1))...
% .*(4*(y.^2).*(4*(y.^2)-a(3))-4.*(x.^2).*(4*(x.^2)-1))...
% .*(4*(y.^2).*(4*(y.^2)-a(end-1))-4.*(x.^2).*(4*(x.^2)-1))...
% .*(4*(y.^2).*(4*(y.^2)-a(end))-4.*(x.^2).*(4*(x.^2)-1));
% p20=@(x,y) (4*(y.^2).*(4*(y.^2)-a(1))-4.*(x.^2).*(4*(x.^2)-1))... 
% .*(4*(y.^2).*(4*(y.^2)-a(end))-4.*(x.^2).*(4*(x.^2)-1));
% 
% f = @(x,y) p1(x,y);g = @(x,y) p2(x,y); 
% f = @(x,y) p5(x,y);g = @(x,y) p7(x,y); numsol = 30;
% f = @(x,y) p20(x,y);g = @(x,y) p18(x,y); numsol = 12; %keep
% f = @(x,y) p8(x,y);g = @(x,y) p9(x,y); %double root
% f = @(x,y) p10(x,y);g = @(x,y) p12(x,y);  % double at boundary x= 1
% f = @(x,y) p11(x,y);g = @(x,y) p13(x,y);  % highly multiple at 0
% f = @(x,y) p14(x,y);g = @(x,y) p15(x,y);  % fine
% f = @(x,y) p16(x,y);g = @(x,y) p17(x,y);  % none
% f = @(x,y) p18(x,y);g = @(x,y) p19(x,y);  % cool

