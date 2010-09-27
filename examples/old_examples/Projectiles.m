%% Solving the Projectile Problem with Chebfuns
% Andre Weideman, 15 Nov--6 Dec, 2009

%% Introduction
% We consider the problem of computing the trajectory of a projectile launched
% at an angle $\theta$ with speed $V$.  Without any air resistance the
% trajectory is well-known to be the parabola
% $$ y = (\tan \theta) \, x - \frac{g}{2 V^2} ( \sec^2 \theta) \, x^2 $$
% from which it is easy to deduce quantities like the maximum height, $H$,
% and the range, $R$, 
% $$ H = \frac{V^2 \sin^2 \theta}{2g}, \qquad R = \frac{V^2 \sin
% 2\theta}{g}. $$
% With more realistic models for air resistance such explicit formulas
% typically do not exist.

%% Linear Model for Air Resistance
% With the linear model for air resistance the equations of motion for the
% horizontal van vertical displacements, $x$ and $y$, are 
% $$ x^{\prime \prime}  =  - c \, x^{\prime}, \qquad y^{\prime \prime} 
% =  -g - c \, y^{\prime}. $$
% Differentiation is with respect to the time, $t$. 
% Here $c$ is proportional to the drag coefficient and $g$ is the
% gravitational constant.    The system is decoupled, so it can be solved
% sequentially, each time involving the operator
% $$ A = \frac{d^2}{dt^2} + c \frac{d}{dt} $$

%%
% First, define a few constants
theta = pi/4; V = 200; g = 9.81; c = 0.01;
%%
% Next, compute a few known quantities from the zero resistance case

Time    = 2*V*sin(theta)/g;    
Reach   = V^2*sin(2*theta)/g;            
Height  = V^2*sin(theta)^2/(2*g);
%%
% The initial conditions are 

x0 = 0; y0 = 0; v0 =  V*cos(theta); w0 =  V*sin(theta);
%%
% We solve the problem using chebops on the time-domain $[0,T]$, where $T$ is the time
% of flight in the non-resistance case (defined above).  
[d,t] = domain(0,Time);
%%
% Set up the operator  
D = diff(d);   
A = [D^2+c*D];  
%%
% and solve the two linear problems in sequence, starting with the
% $x$-problem
A.lbc(1) = x0;
A.lbc(2) = {D,V*cos(theta)};
x = A\0;
%%
% and then the $y$-problem
A.lbc(1) = y0;
A.lbc(2) = {D,V*sin(theta)};
y = -A\g; 
%%
% Also compute the theoretical solution in the no-resistance case,
% for comparison
X = V*cos(theta)*t; Y = V*sin(theta)*t-1/2*g*t.^2;  
%%
% and plot
figure(1);
plot(x,y,X,Y,'LineWidth',2); axis equal;
legend('Linear resistance','No resistance','Location','South')
axis([0 Reach 0 Height])
%%
% The maximum height is computed with the max function. The reach is
% computed by first computing the time of flight with the roots function 
% (ignore the first root, which corresponds to the initial position) and 
% then plugging in this root for $t$ in the displacement function
H = max(y)
t = roots(y);               
R = x(t(2))              
%%
% There exists an explicit formula for the maximum height, namely
Htheory = (V/c)*sin(theta)-(g/c^2)*log(1+(c*V/g)*sin(theta))      
%%
% which agrees with the value of $H$ computed above to about twelve digits
% or so.  The formula for the reach can be expressed in terms of the
% Lambert W-function, and a computation in Maple yielded
Rtheory = 3.407369784107551e+003
%%
% Somewhat surprisingly, this agrees only to about nine places with the
% value of $R$ computed by chebfuns.  (But presumably in practice there
% will be no need to compute the reach to an accuracy of less than a mm! :-)
%% Quadratic Model for Air Resistance
% The quadratic model reads
% $$ x^{\prime \prime}   =  - c \sqrt{(x^{\prime})^2+ (y^{\prime})^2} \, x^{\prime}, \qquad
% y^{\prime \prime}   =   -g - c \sqrt{(x^{\prime})^2+ (y^{\prime})^2} \,
% y^{\prime}  $$
%%
% Unlike the linear model which decouples, this is a coupled system and we
% solve it with nonlinear chebops.  The no-resistance solution is used as initial guess.
% To make it more realistic, we have to decrease the value of $c$ first
c = 1e-5;
[d,t,N] = domain(0,Time);
N.op = @(u) [diff(u(:,1),2) + c*sqrt(diff(u(:,1).^2+diff(u(:,2).^2))).*diff(u(:,1)), ...
             diff(u(:,2),2) + c*sqrt(diff(u(:,1).^2+diff(u(:,2).^2))).*diff(u(:,2))+g];
N.lbc = {@(u) u(:,1)-x0, @(u) diff(u(:,1))-V*cos(theta), ...
         @(u) u(:,2)-y0, @(u) diff(u(:,2))-V*sin(theta)};
X = V*cos(theta)*t; Y = V*sin(theta)*t-1/2*g*t.^2;     
N.guess = [X,Y];
[u nrmduvec] = N\0;
plot(u(:,1),u(:,2),X,Y,'LineWidth',2); axis equal;
legend('Quadratic resistance','No resistance','Location','South')
axis([0 Reach 0 Height])
%%
% The reach and maximum height is computed as before
H = max(u(:,2))
t = roots(u(:,2));               
R = u(t(2),1) 
%%
% It has not yet been established how accurate these approximations are.
  
 

 
