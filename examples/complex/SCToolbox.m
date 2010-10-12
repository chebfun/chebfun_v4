%% SCHWARZ-CHRISTOFFEL TOOLBOX AND CHEBFUN
% Nick Trefethen, 6 October 2010

%%
% (Chebfun example complex/SCToolbox.m)

%%
% Chebfun's SCRIBBLE command is good for illustrating conformal maps in the
% complex plane.  For example, the hyperbolic tangent function maps infinite
% strips onto lens-shaped regions with vertices at 1 and -1, and this is
% the basis of numerical methods based on sinc functions, discussed
% in books and papers by F. Stenger.  Here is an illustration of the tanh map.
%%
% <latex> \vspace{-2em}</latex>
LW = 'linewidth'; lw = 1.2;
w = .07-.15i+2.2*scribble('INFINITE STRIP');
bndry = chebfun('1i*pi/8 + t',[-3 3]);
bndry = [bndry; -bndry];
figure, subplot(2,1,1)
plot(w,LW,lw), axis equal
hold on, plot(bndry,'k',LW,lw), xlim([-3,3])
subplot(2,1,2)
g = @(z) tanh(z);
plot(g(w),LW,lw), axis equal
hold on, plot(g(bndry),'k',LW,lw), xlim([-2 2])

%%
% More generally, suppose we want to work with conformal maps from one
% polygon to another (possibly with vertices at infinity)
% but the polygons aren't quite as simple as in the tanh case.
% Then we can use the Schwarz-Christoffel formula, which is
% implemented numerically in Driscoll's Schwarz-Christoffel Toolbox.
% Here is an illustration.
%%
% <latex> \vspace{-2em}</latex>
w = .07 + 0.3i + 3*scribble('INFINITE STRIP');
bndry = [chebfun('1i + t',5*[-1 1]); chebfun('t',5*[-1 1])];
figure, subplot(2,1,1)
plot(w,LW,lw), axis equal
hold on, plot(bndry,'k',LW,lw), xlim(4.5*[-1,1])
subplot(2,1,2)
p = polygon([-1 -0.5 0 0.5 1 1+.5i -1+.5i]);
f = stripmap(p,[1 5]);
z = prevertex(f);
g = stripmap(p,z-z(3),[1 5]);
gw = chebfun(@(x) g(w(x)),w.ends,'eps',1e-4,'extrapolate','on');
plot(gw,LW,lw), axis equal
vp = vertex(p); vp = vp([1:end 1]);
hold on, plot(vp,'k',LW,lw), xlim(1.5*[-1 1])

%%
% References:
%
% T. A. Driscoll, Algorithm 843: Improvements to the
% Schwarz-Christoffel Toolbox for Matlab, ACM Transactions on
% Mathematical Software 31 (2005), 239-251.
%
% T. A. Driscoll and L. N. Trefethen, Schwarz-Christoffel Mapping,
% Cambridge U. Press, 2002.
%
% F. Stenger, Numerical Methods Based on Sinc and
% Analytic Functions, Springer, 1993.  
%
