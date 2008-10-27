%% CHEBFUN GUIDE 5: COMPLEX CHEBFUNS
% Lloyd N. Trefethen, April 2008

%% 5.1  Complex functions of a real variable

%%
% One of the attractive features of Matlab is that it handles
% complex arithmetic well.
% For example, here are 20 points on the upper half
% of the unit circle in the complex plane:

s = linspace(0,pi,20);
f = exp(1i*s);
plot(f,'.')
axis equal
  
%%
% In Matlab, both the variables i and j are initialized
% as i, the square root of -1, but this code uses
% 1i instead (just as one might write,
% for example, 3+2i or 2.2-1.1i).  Writing the imaginary unit
% in this fashion is a common trick among Matlab programmers,
% for it avoids the risk of surprises caused by i or j being
% overwritten by other values.
% The "axis equal" command ensures that the real and
% imaginary axes are scaled equally.

%%
% Here is a chebfun analogue.

s = chebfun('s',[0 pi]);
f = exp(1i*s);
plot(f)
axis equal

%%
% The chebfun semicircle is represented by a polynomial of low degree:

length(f)
plot(f,'.-')
axis equal

%%
% We can have fun with variations on the theme:

subplot(1,2,1), g = s.*exp(10i*s); plot(g), axis equal
subplot(1,2,2), h = exp(2i*s)+.3*exp(20i*s); plot(h), axis equal

%%

subplot(1,2,1), plot(g.^2), axis equal
subplot(1,2,2), plot(exp(h)), axis equal

%%
% Such plots make pretty pictures, but as always with chebfuns,
% the underlying operations involve precise mathematics
% carried out to many digits
% of accuracy.  For example, the integral of g is -pi*i/10,

sum(g)

%%
% and the integral of h is zero:

sum(h)
%%
% Piecewise smooth complex chebfuns are also possible.
% For example, the following starts from a chebfun z defined
% as (1+0.5i)s for s on the interval [0,1] and
% 1+0.5i-2(s-1) for s on the interval [1,2].

z = chebfun('(1+.5i)*s','1+.5i-2*(s-1)',[0 1 2]);
subplot(1,2,1), plot(z), axis equal, grid on
subplot(1,2,2), plot(z.^2), axis equal, grid on

%%
% Actually, this way of constructing a piecewise chebfun is
% rather clumsy.  An easier method is to use the "vertcat" feature
% of the chebfun system, in which a construction like [f; g; h] constructs
% a single chebfun with the same values as f, g, and h, but on a
% domain concatenated together.  Thus if the domains of f, g, h are
% [a,b], [c,d], and [e,d], then [f; g; h] has three pieces with domains
% [a,b], [b,b+(d-c)], [b+(d-c),b+(d-c)+(d-e)].  Using this trick, 
% we can construct the chebfun z above in the following alternative manner:

  s = chebfun('s',[0 1]);
  zz = [(1+.5i)*s; 1+.5i-2*s];
  norm(z-zz)

%% 5.2 Analytic functions and conformal maps
%
% A function is *analytic* if it is differentiable in the complex sense, or
% equivalently, if it has a convergent Taylor series near each point.
% Analytic functions do interesting things in the complex plane.
% In particular, away from points where the derivative is zero, they
% are *conformal maps*, which means that though they may scale and
% rotate an infinitesimal region, they preserve angles
% between intersecting curves.

%%
% One can illustrate such maps with chebfuns.
% For example, suppose we define R to be
% a chebfun corresponding to the four sides of a rectangle, and
% we define X to be another chebfun corresponding to a cross inside R. 

s = chebfun('s',[0 1]);
R = [1+s; 2+2i*s; 2+2i-s; 1+2i-2i*s];
clf, subplot(1,2,1), plot(R), grid on, axis equal
X = [1.3+1.5i+.4*s; 1.5+1.3i+.4i*s];
hold on, plot(X,'r')

%%
% Here we see what happens to R and X under the maps z^2 and exp(z):

clf
subplot(1,2,1), plot(R.^2), grid on, axis equal
hold on, plot(X.^2,'r')
subplot(1,2,2), plot(exp(R)), grid on, axis equal
hold on, plot(exp(X),'r')

%%
% We can take the same idea further and construct a grid in the
% complex plane, each segment of which is a piece of a chebfun that
% happens to be linear:

  x = chebfun('x');
  S = chebfun;                  % make an empty chebfun
  for d = -1:.2:1
    S = [S; d+1i*x; 1i*d+x];    % add 2 more lines to the collection
  end
  clf, subplot(1,2,1), plot(S), axis equal

%%
% Here are the exponential and tangent of the grid:

  subplot(1,2,1), plot(exp(S)), axis equal
  subplot(1,2,2), plot(tan(S)), axis equal

%%
% Here is a sequence that puts all three images together on
% a single scale:
 
  clf
  plot(S), hold on
  plot(1.6+exp(S))
  plot(6.6+tan(S))
  axis equal, axis off

%%
% A particularly interesting set of conformal maps are the
% *Moebius transformations*, the rational functions of the form (az+b)/(cz+d)
% for constants a,b,c,d.  For example, here is a square and its
% image under the map w = 1/(1+z), and the image of the image under the
% same map, and the image of the image of the image.  We also plot
% the limiting point given by the equation z = 1/(1+z), i.e., 
% z = (sqrt(5)-1)/2.

s = chebfun('s',[0 1]);
S1 = [-.5i+s; 1-.5i+1i*s; 1+.5i-s; .5i-1i*s];
clf
S2 = 1./(1+S1); S3 = 1./(1+S2); S4 = 1./(1+S3);
plot(S1,'b')
hold on, axis equal
plot(S2,'r'), plot(S3,'g'), plot(S4,'m')
plot((sqrt(5)-1)/2,0,'.k')

%%
% One could make more beautiful pictures along these lines with
% commands of the form fill(chebfun), but Matlab's "fill" command
% has not yet been overloaded for chebfuns.

%% 5.3 Contour integrals
% If s is a real parameter and z(s) is a complex function of s,
% then we can define a contour integral in the complex plane like this:
%
%        INT f(z(s)) z'(s) ds
%
% The contour in question is the curve described by z(s) as s varies
% over its range.

%%
% For example, in the example at the end of Section 5.1
% the contour consists of two straight segments
% that begin at 0 and end at -1+.5i.  We can compute the integral of 
% exp(-z^2) over the contour like this:

  f = exp(-z.^2);
  I = sum(f.*diff(z))

%%
% Notice how easily the contour integral is realized in the
% chebfun system, even over a contour consisting of several pieces.
% This particular integral is related to the complex error function [Weideman 1994].
  
%%
% According to *Cauchy's theorem*, the integral of an analytic function
% around a closed curve is zero, or equivalently, the integral between two
% points z1 and z2 is path-independent.  To verify this, we can
% compute the same integral over the straight segment going directly from
% 0 to -1+0.5i:

  w = chebfun('(-1+.5i)*s',[0 1]);
  f = exp(-w.^2);
  I2 = sum(f.*diff(w))

%%
% A *meromorphic function* is a function that is analytic in a region of interest
% in the complex plane apart from possible poles.
% According to the *Cauchy integral formula*, (1/2i*pi) times the integral of
% a function f around a closed contour is equal to the sum of the residues
% of f associated with any poles it may have in the enclosed region.   The
% *residue* of f at a point z0 is the coefficient of the degree -1 term in
% its Laurent expansion at z0.  For example, the function exp(z)/z^3
% has Laurent series z^(-3) + z^(-2) + (1/2)z^(-1) + (1/6)z^0 + ...
% at the origin, and so its residue there is 1/2.  We can confirm this
% by computing the contour integral around a circle:

z = chebfun('exp(1i*s)',[0 2*pi]);
f = exp(z)./z.^3;
I = sum(f.*diff(z))/(2i*pi)

%%
% Notice that we have just computed the degree 2 Taylor coefficient of exp(z).

%%
% When the chebfun system integrates around a circular contour
% like this, it does not use the fact that the integrand is
% periodic.  That would be Fourier analysis as opposed to Chebyshev
% analysis, and a "fourfun" system would be more efficient for such
% problems [Davis 1959].  Chebyshev analysis is more flexible, however, since it does
% not require periodicity, and the loss in efficiency is only about
% a factor of pi/2 [Hale & Trefethen 2008].

%%
% The contour does not have to have radius 1, or be centered at the origin:
z = chebfun('1+2*exp(1i*s)',[0 2*pi]);
f = exp(z)./z.^3;
I2 = sum(f.*diff(z))/(2i*pi)

%% 
% Nor does the contour have to be smooth.
% Here let us compute the same result by integration over a square:

s = chebfun('s',[-1 1]);
z = [1+1i*s; 1i-s; -1-1i*s; -1i+s];
f = exp(z)./z.^3;
I3 = sum(f.*diff(z))/(2i*pi)

%%
% In the chebfun system one
% can also construct more interesting contours of the kind that
% appear in complex variables texts.  Here is an example:

  c = [-2+.05i -.2+.05i -.2-.05i -2-.05i];    % 4 corners
  s = chebfun('s',[0 1]);
  z = [c(1)+s*(c(2)-c(1))
       c(2)*c(3).^s./c(2).^s
       c(3)+s*(c(4)-c(3))
       c(4)*c(1).^s./c(4).^s];
  clf, plot(z), axis equal, axis off

%%
% The integral of f(z) = log(z)tanh(z) around this contour will
% be equal to 2i*pi times the sum of the residues at the poles
% of f at +-0.5i*pi.

f = log(z).*tanh(z);
I = sum(f.*diff(z))
Iexact = 4i*pi*log(pi/2)

%% 5.4 Cauchy integrals and locating zeros and poles
%
% Here are some further examples of computations with
% Cauchy integrals.  The Bernoulli number B_k is 
% k! times the kth Taylor coefficient of z/((exp(z)-1).
% Here is B_10 compared with its exact value 5/66.

k = 10;
z = chebfun('5*exp(1i*s)',[0 2*pi]);
f = z./((exp(z)-1));
B10 = factorial(k)*sum((f./z.^(k+1)).*diff(z))/(2i*pi)
exact = 5/66

%%
% Notice that we have taken z to be a circle of radius 5.
% If the radius is 1, the accuracy is a good deal lower:

z = chebfun('exp(1i*s)',[0 2*pi]);
f = z./((exp(z)-1));
B10 = factorial(k)*sum((f./z.^(k+1)).*diff(z))/(2i*pi)

%%
% This problem of numerical instability would arise no matter
% how one calculated the integral over the unit circle; it is not
% the fault of the chebfun system.

%%
% Another use of Cauchy integrals is to count zeros or
% poles of functions in specified regions.  According to the
% *principle of the argument*, the number of zeros
% minus the number of poles of f in a region is
%
%   N = (1/2i*pi) INT (f'/f) dz
%
% where the integral is taken over the boundary.  Since f' = df/dz
% = (df/ds)(ds/dz), we can rewrite this as
%
%   N = (1/2i*pi) INT (df/ds)/f ds.
%
% (What is really going on here is a calculation of the change of the
% argument of f as the boundary is traversed.  In principle it
% should be possible to calculate this by the Matlab commands "angle" and "unwrap",
% but these have not yet been overloaded for chebfuns.)
% For example, the function f(z) = sin(z)^3 + cos(z)^3 clearly has no poles;
% how many zeros does it have in the disk about 0 of radius 2?
% The following calculation shows that the answer is 3:

z = chebfun('2*exp(1i*s)',[0 2*pi]);
f = sin(z).^3 + cos(z).^3;
N = sum((diff(f)./f))/(2i*pi)

%%
% Variations on this idea enable one to locate zeros and poles as well as
% count them.  For example, we can locate a single zero with the formula
%
%   r = (1/2i*pi) INT z (df/ds)/f ds
%
% [McCune 1966].  Here is the zero of the function above in the unit disk:

z = chebfun('exp(1i*s)',[0 2*pi]);
f = sin(z).^3 + cos(z).^3;
r = sum(z.*(diff(f)./f))/(2i*pi)

%%
% Since this zero happens to be real, we can check the result
% by a more ordinary real chebfun calculation:

x = chebfun('x');
f = sin(x).^3 + cos(x).^3;
r = roots(f)

%%
% To find multiple zeros via Cauchy integrals, see [Delves & Lyness 1967].

%% 5.5 Alphabet soup
% 
% One can do some silly things with piecewise smooth chebfuns.  
% For example, here is a chebfun defined
% on the interval [0,7] that prints the initials LNT.  One could polish
% up and extend this construction by defining 26 suitable M-functions.

LW = 'linewidth'; lw = 2.5;
s = chebfun('s',[0 1]);
w = [1+.8i-.8i*s; 1+.6*s;                     % L
     2+.8i*s; 2+.8i+(-.8i+.6)*s; 2.6+.8i*s;   % N
     3.3+.8i*s; 3+.8i+.6*s];                  % T
clf, plot(w,'k',LW,lw), axis equal, axis off

%%
% As always, this is a precisely defined mathematical function:

sum(w)
max(abs(w))
w(3.5)

%%
% We can transform the function in various ways:

subplot(1,2,1), plot(sqrt(w),'k',LW,lw), axis equal, axis off
subplot(1,2,2), plot(1./w,'k',LW,lw), axis equal, axis off

%%

subplot(1,2,1), plot(cosh(w),'k',LW,lw), axis equal, axis off
subplot(1,2,2), plot( cos(w),'k',LW,lw), axis equal, axis off

%% 5.6  References
%
% [Davis 1959] P. J. Davis, "On the numerical integration of periodic analytic
% functions", in R. E. Langer, ed., On Numerical Integration,
% Math. Res. Ctr., U. of Wisconsin, 1959, pp. 45-59.
%
% [Delves & Lyness 1967] L. M. Delves and J. N. Lyness, "A numerical
% method for locating the zeros of an analytic function," Mathematics
% of Computation 21 (1967), 543--560.
%
% [Hale & Trefethen 2008] N. Hale and L. N. Trefethen,
% "New quadrature formulas from conformal maps", SIAM Journal
% on Numerical Analysis 46 (2008), 930-948.
%
% [McCune 1966] J. E. McCune, "Exact inversion of dispersion relations",
% Physics of Fluids 9 (1966), 2082-2084.
%
% [Weideman 1994] J. A. C. Weideman, "Computation of the complex error
% function", SIAM Journal on Numerical Analysis 31 (1994), 1497-1518.
