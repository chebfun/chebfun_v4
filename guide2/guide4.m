%% CHEBFUN2 GUIDE 4: COMPLEX-VALUED CHEBFUN2 OBJECTS
% A. Townsend, March 2013

%% 4.1 HOLOMORPHIC FUNCTIONS
% An analytic function f(z) can be thought of as a complex valued 
% function of two real variables f(x,y) = f(x+iy). If the Chebfun2 
% constructor is given an anonymous function with one argument, 
% it assumes that argument is a complex variable. For instance, 

f = chebfun2(@(z) sin(z));   % f(z) = sin(z) 
f(1+1i), sin(1+1i)           % evaluation 

%% 
% These functions can be visualised by using a technique known as phase
% portrait plots. Given a complex number z = r*exp(1i*theta), the phase, theta,
% can be represented by a colour. We follow Wegert's colour 
% recommendations [Wegert 2012]. Roughly, the colour wheel is such that red
% is for a phase of 0, then as the phase increases the colours 
% go through yellow, green, blue, violet. For example, 

f = chebfun2(@(z) sin(z)-sinh(z),2*pi*[-1 1 -1 1]);
plot(f)

%% 
% Many properties of analytic functions can be visualised by these types
% of plots [Wegert 2012] such as the location of zeros and their multiplicities.
% Can you work out the multiplicity of the root at z=0 from this plot?

%%
% At present, since Chebfun2 only represents smooth functions, a trick is
% required to draw pictures like these for functions with poles [Trefethen 2013].  However, 
% for functions with branch points, or essential singularities it is currently
% not possible in Chebfun2 to draw these plots.

%% 4.2 INTERSECTIONS OF CURVES
% The determination of the intersections of real parameterised complex curves can be expressed as a
% bivariate rootfinding problem.  For instance, here are the intersections
% between the 'splat' curve [Guttel Example 2010] and a 'figure-of-eight'
% curve. 

t = chebfun('t',[0,2*pi]);
splat = exp(1i*t) + (1+1i)*sin(6*t).^2;     % splat curve
figOfAte = cos(t) + 1i*sin(2*t);            % figure of eight curve
plot(splat), hold on, plot(figOfAte,'r'), axis equal

f = chebfun2(@(s,t) splat(t) - figOfAte(s),[0 2*pi 0 2*pi]); % rootfinding
r = roots(real(f),imag(f));                 % calculate intersections
plot(real(splat(r(:,2))),imag(splat(r(:,2))),'.k','markersize',20) 

%%
% Chebfun2 uses an algorithm based on Marching Squares though other 
% algorithms can be used [Nakatsukasa, Noferini & Townsend Example 2013].

%% 4.3 REFERENCES
%%
% [Guttel Example 2010] S. Guttel, 
% http://www2.maths.ox.ac.uk/chebfun/examples/geom/html/Area.shtml
%% 
% [Nakatsukasa, Noferini & Townsend Example 2013] Y. Nakatsukasa, V. Noferini
% and A. Townsend, Computing common roots of two bivariate functions,
% Chebfun Example, February 2013. 
%%
% [Trefethen 2013] L. N. Trefethen, Phase Portraits for functions with poles, 
% http://www2.maths.ox.ac.uk/chebfun/chebfun2/examples/ComplexAnalysis/PortraitsWithPoles.shtml
%%
% [Wegert 2012] E. Wegert, Visual Complex Functions: An Introduction with
% Phase Portraits, Springer Basel, 2012
