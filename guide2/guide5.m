%% CHEBFUN2 GUIDE 5: VECTOR CALCULUS AND DIFFERENTIAL GEOMETRY
% A. Townsend, March 2013

%% 5.1 WHAT IS A CHEBFUN2V? 
% Chebfun2v objects represent vector valued functions. We use a lower case
% letter, f, for a chebfun2 object and an upper case letter, F, for a
% chebfun2v object. 

%%
% Chebfun2v represents a vector-valued function F(x,y) = (f(x,y);g(x,y)) 
% by approximating each component by a low rank approximant. 
% There are two ways to form a chebfun2v object: either by explicitly 
% calling the constructor or by vertical concatenation of two chebfun2 objects. 
% Here are these two alternatives:

d = [0 1 0 2];
F = chebfun2v(@(x,y) sin(x.*y), @(x,y) cos(y),d); % calling the constructor
f = chebfun2(@(x,y) sin(x.*y),d); g = chebfun2(@(x,y) cos(y),d);
G = [f;g]                                         % vertical concatenation

%% 
% Displaying a chebfun2v shows that it is a vector of two chebfun2
% objects.

%% 5.2 ALGEBRAIC OPERATIONS 
% Chebfun2v objects are useful for performing 2D vector
% calculus. The basic algebraic operations are scalar multiplication, 
% vector addition, dot product and cross product. 

%%
% Scalar multiplication is the product of a scalar function with a 
% vector function

f = chebfun2(@(x,y) exp( -(x.*y).^2/20 ) ,d);   % scalar valued function 
f.*F

%%  
% Vector addition yields another chebfun2v and satisfies the 
% parallelogram law:

plaw = abs((2*norm(F)^2 + 2*norm(G)^2) - (norm(F+G)^2 + norm(F-G)^2));
fprintf('Parallelogram law holds with error = %10.5e\n',plaw)


%%
% The dot product combines two vector functions into a scalar function. 
% If the dot product of two chebfun2v objects takes the value 
% zero at some (x,y) then the vector valued functions are orthogonal at 
% (x,y).  For example, the following code segment determines a curve along
% which two vector-valued functions are orthogonal:

F = chebfun2v(@(x,y) sin(x.*y), @(x,y) cos(y),d);
G = chebfun2v(@(x,y) cos(4*x.*y), @(x,y) x + x.*y.^2,d);
plot(roots(dot(F,G))), axis equal, axis(d)

%% 
% The cross product for 2D vector fields is

help chebfun2v/cross 

%% 5.3 DIFFERENTIAL OPERATIONS
% Vector calculus also involves various differential operators defined 
% on scalar or vector valued functions such as gradient, 
% curl, divergence, and Laplacian.

%%
% The gradient of a chebfun2 is, geometrically, the direction and magnitude 
% of steepest ascent of f. If the gradient of f is 0 at (x,y) then f has a 
% critical point at (x,y). Here are the
% critical points of a sum of Gaussian bumps:

f = chebfun2(0);
for k = 1:10 
    x0 = 2*rand-1; y0=2*rand-1;
    f = f + chebfun2(@(x,y) exp(-10*((x-x0).^2 + (y-y0).^2)));
end
plot(f), hold on 
r = roots(gradient(f));
plot3(r(:,1),r(:,2),f(r(:,1),r(:,2)),'k.','markersize',20), hold off

%%
% The curl of 2D vector function is a scalar function defined by

help chebfun2v/curl 

%%
% If the chebfun2v F describes a vector velocity field of fluid flow, 
% for example, then curl(F) is the scalar function equal
% to twice the angular speed of a particle in the flow at each point. 
% A particle moving in a gradient field has zero angular speed and hence,
% the curl of the gradient is zero.  We can check this numerically:

norm(curl(gradient(f)))

%% 
% The divergence of a chebfun2v is defined as 

help chebfun2v/divergence

%%
% This measures a vector field's distribution of sources or sinks.  
% The Laplacian is closely related and is the divergence of the gradient,

norm(laplacian(f) - divergence(gradient(f)))

%% 5.4 LINE INTEGRALS 
% Given a vector field F we can compute the line integral along a curve
% with the command integral, as defined as

help chebfun2v/integral

%%
% The gradient theorem says that if F is a gradient field then the 
% line integral along a smooth curve only depends on the end points of that
% curve. We can check this numerically:

f = chebfun2(@(x,y) cos(10*x.*y.^2) + exp(-x.^2));% chebfun2 object
F = gradient(f);                                  % gradient (chebfun2v)
C = chebfun(@(t) t.*exp(10i*t),[0 1]);            % spiral curve
v = integral(F,C);ends = f(cos(10),sin(10))-f(0,0);% line integral
abs(v-ends)                                       % gradient theorem

%% 5.5 PHASE PORTRAIT
% A phase portrait is a graphical representation of a system of 
% trajectories for a two variable autonomous dynamical system. In 
% Chebfun2 we can plot phase portraits by using the quiver command, which
% has been overloaded to plot the vector field. 
% 
% In addition, Chebfun2 makes it easy to compute and plot individual 
% trajectories of a vector field. If F is a chebfun2v, then 
% ode45(F,tspan,y0) solves the autonomous system dx/dt=f(x,y), dy/dt=g(x,y),
% where f and g are the first and second components of F. Given a 
% prescribed time interval and initial conditions, this command returns a 
% complex valued chebfun representing the trajectory in the form 
% $x(t) + iy(t)$. For example:

d = 0.04; a=1; b=-.75;
F = chebfun2v(@(x,y)y, @(x,y)-d*y - b*x - a*x.^3, [-2 2 -2 2]);
[t y]=ode45(F,[0 40],[0,.5]);
plot(y,'r'), hold on,
quiver(F,'b'), axis equal
title('The Duffing oscillator','FontSize',16), hold off

%% 5.6 PARAMETRIC SURFACES
% So far, we have been exploring chebfun2v objects with two components, but
% to represent parametric surfaces, i.e. surfaces in $R^3$ which
% are defined by parametric equations with two parameters, we will need a
% third component. For example, we can represent the unit sphere via spherical 
% coordinates as follows:

th = chebfun2(@(th,phi) th, [0 pi 0 2*pi]);
phi = chebfun2(@(th,phi) phi, [0 pi 0 2*pi]);

x = sin(th).*cos(phi);
y = sin(th).*sin(phi);
z = cos(th); 

% A chebfun2v with three components representing the unit sphere:
F = [x;y;z]; 
surf(F), axis equal

%%
% Above, we have formed a chebfun2v with three components by vertical 
% concatenation of chebfun2 objects. However, for familiar surfaces such as
% cylinders, spheres, and ellipsoids we have overloaded the commands
% CYLINDER, SPHERE, and ELLIPSOID to generate these surfaces for you. 
% For example, a cylinder of radius 1 and height 5 can be constructed like this:

h = 5; 
r = chebfun(@(th) 1+0*th,[0 h]);
F = cylinder(r);
surf(F)

%% 
% An important class of parametric surfaces are surfaces of revolution,
% which are formed by revolving a curve in the left half plane about the
% z-axis. The CYLINDER command can be used to generate surfaces of 
% revolution. For example: 

f = chebfun(@(t) (sin(pi*t)+1.1).*t.*(t-10),[0 5]);
F = cylinder(f);
surf(F)

%%
% Given a chebfun2v representing a surface, the normal can be computed by 
% the Chebfun2v NORMAL command.  Here are the unit normal vectors of a torus:

r1 = 1; r2 = 1/3;   % inner and outer radius
d = [0 2*pi 0 2*pi];
u = chebfun2(@(u,v) u,d);
v = chebfun2(@(u,v) v,d);
F = [-(r1+r2*cos(v)).*sin(u); (r1+r2*cos(v)).*cos(u); r2*sin(v)];  % torus

surf(F), hold on
quiver3(F(1),F(2),F(3),normal(F,'unit'),'numpts',10)
axis equal, hold off

%%
% Once we have the surface normal vectors we can compute, for instance, 
% the volume of the torus by applying Divergence theorem:
% $$ \int\int_V\int div(G) dV = \int_S\int G\cdot d\mathbf{S},$$
% where $div(G)=1$. Instead of integrating over the 3D volume, which is 
% currently not possible in Chebfun2, we integrate over the 2D surface:

G = F./3;  % full 3D divergence of G is 1 because F = [x;y;z]. 
integral2(dot(G,normal(F)))
exact = 2*pi^2*r1*r2.^2

%%
% Chebfun2v objects with three components come with a warning. Chebfun2
% works with functions of two real variables and therefore, operations such
% as curl and divergence (in 2D) have little physical meaning to the 
% represented 3D surface.  The reason we can compute the 
% volume of the torus (above) is because we are using the Divergence Theorem and
% circumnavigating the 3D divergence.

%%
% To finish this section we represent the Klein Bagel. The solid black 
% line shows the parameterisation seam and is displayed with the syntax 
% surf(F,'-'), see [Platte March 2013] for more on parameterised surfaces.

u = chebfun2(@(u,v) u, [0 2*pi 0 2*pi]);
v = chebfun2(@(u,v) v, [0 2*pi 0 2*pi]);
x=(3+cos(u/2).*sin(v)-sin(u/2).*sin(2*v)).*cos(u);
y=(3+cos(u/2).*sin(v)-sin(u/2).*sin(2*v)).*sin(u);
z=sin(u/2).*sin(v)+cos(u/2).*sin(2*v);
surf([x;y;z],'-k','FaceAlpha',.6), camlight left, colormap(hot)
axis tight equal off

%% 5.7 MORE INFORMATION 
% More information on vector calculus in Chebfun2 is available in the
% Chebfun2 Examples.  Vector calculus is also described in [Townsend & Trefethen
% 2013]. For more details about particular commands type, for instance, 

help chebfun2v/plus

%% 5.8 REFERENCES
%%
% [Platte March 2013] R. Platte, Parameterizable surfaces, Chebfun2
% Example: http://www2.maths.ox.ac.uk/chebfun/examples/geom/html/ParametricSurfaces.shtml
%%
% [Townsend & Trefethen 2013] A. Townsend and L. N. Trefethen, An extension
% of Chebfun to two dimensions, submitted. 