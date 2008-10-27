%% CHEBFUN GUIDE 3: ROOTFINDING AND MINIMA AND MAXIMA
% Lloyd N. Trefethen, April 2008

%% 3.1 roots
% Chebfuns come with a global rootfinding capability -- the
% ability to find all the zeros of a function in its region
% of definition.  For example, here is a polynomial with two
% roots in [-1,1]:

  x = chebfun('x');
  p = x.^3 + x.^2 - x;
  r = roots(p)

%%
% We can plot p and its roots like this:
  plot(p)
  hold on, plot(r,p(r),'.r')

%%
% Of course one does not need chebfuns to find roots of a polynomial:
  roots([1 1 -1 0])

%%
% A more substantial example of rootfinding involving a Bessel function
% was shown in Section 1.  Here is a similar calculation for
% the Airy functions Ai and Bi, modeled after the page on "Airy functions"
% at WolframMathWorld.  (The reason for the "real" command is a
% bug in Matlab: Matlab's "airy" command gives spurious nonzero imaginary
% parts, at the level of rounding errors, when applied to some real
% arguments, such as x=-2.)
  
  Ai = chebfun('real(airy(0,x))',[-10,3]);
  Bi = chebfun('real(airy(2,x))',[-10,3]);
  hold off, plot(Ai,'r')
  hold on, plot(Bi,'b')
  rA = roots(Ai); plot(rA,Ai(rA),'.r')
  rB = roots(Bi); plot(rB,Bi(rB),'.b')
  axis([-10 3 -.6 1.5]), grid on

%%
% Here for example are the three roots of Ai and Bi closest to 0:

  [rA(end-2:end) rB(end-2:end)]

%%
% The chebfun system finds roots by a method due to Boyd and Battles
% [Boyd 2002, Battles 2006].  If the chebfun is of degree much greater than about 100,
% it is broken into smaller pieces recursively.  On each small piece
% zeros are then found as eigenvalues of a "colleague matrix", the analogue
% for Chebyshev polynomials of a companion matrix for monomials [Good 1961].
% This method can be startlingly fast and accurate.  For example,
% here is a sine function with 11 zeros:

  f = chebfun('sin(pi*x)',[0 10]);
  lengthf = length(f)
  tic, r = roots(f); toc
  r

%%
% A similar computation with 101 zeros comes out equally well:
  f = chebfun('sin(pi*x)',[0 100]);
  lengthf = length(f)
  tic, r = roots(f); toc
  fprintf('%22.14f\n',r(end-4:end))

%%
% And here is the same on an interval with 1001 zeros.  We
% turn splitting off so as to work with pure global polynomials.
  splitting off
  f = chebfun('sin(pi*x)',[0 1000]);
  lengthf = length(f)
  tic, r = roots(f); toc
  fprintf('%22.13f\n',r(end-4:end))
  splitting on

%%
% With the ability to find zeros, we can solve a variety of
% nonlinear problems.  For example, where do the curves
% x and cos(x) intersect?  Here is the answer.

  x = chebfun('x',[-2 2]);
  hold off, plot(x)
  f = cos(x);
  hold on, plot(f,'k')
  r = roots(f-x)
  plot(r,f(r),'or')

%%
% All of the examples above concern chebfuns consisting of
% a single fun.  If there are several funs, then roots are
% included at jumps as necessary.  The following
% example shows a chebfun with 26 pieces.  It has
% nine zeros: one within a fun, eight at jumps between funs.

  x = chebfun('x',[-2 2]);
  f = x.^3 - 3*x - 2 + sign(sin(20*x));
  hold off, plot(f), grid on
  r = roots(f);
  hold on, plot(r,0*r,'.r')

%% 3.2 min, max, abs, sign, round, floor, ceil
% Rootfinding is more central to the chebfun system than
% one might at first imagine, because a number
% of commands, when applied to smooth chebfuns, must
% produce non-smooth results, and it is rootfinding that
% tells us where to put the discontinuities.
% For example, the "abs" command introduces breakpoints
% wherever the argument goes through zero.  Here we 
% see that x consists of a single piece, whereas abs(x) consists
% of two pieces.

  x = chebfun('x')
  absx = abs(x)
  subplot(1,2,1), plot(x,'.-')
  subplot(1,2,2), plot(absx,'.-')

%%
% We saw this effect already in Section 1.4.
% Another similar effect shown in that section occurs with
% min(f,g) or max(f,g).  Here, breakpoints are introduced
% at points where f-g is zero:

  f = min(x,-x/2), subplot(1,2,1), plot(f,'.-')
  g = max(.6,1-x.^2), subplot(1,2,2), plot(g,'.-')

%%
% The function "sign" also introduces breaks, as illustrated
% in the last section.
% The commands "round", "floor", and "ceil" behave like this too.
% For example, here is exp(x) rounded to nearest multiples of 0.5:

  g = exp(x);
  clf, plot(g)
  gh = 0.5*round(2*g);
  hold on, plot(gh,'r');
  grid on

%% 3.3 Local extrema: roots(diff(f))
% Local extrema of smooth functions can be located by finding
% zeros of the derivative.  For example, here is a variant of
% the Airy function again, with all its extrema in its range of
% definition located and plotted.
  f = chebfun('exp(real(airy(x)))',[-15,0]);
  clf, plot(f)
  r = roots(diff(f));
  hold on, plot(r,f(r),'.r'), grid on

%%
% This method will find non-smooth extrema as well as smooth ones,
% since these correspond to "zeros" of the derivative where
% the derivative jumps from one sign to the other.  Here is an
% example.
  x = chebfun('x');
  f = exp(x).*sin(30*x);
  g = 2-6*x.^2;
  h = max(f,g);
  clf, plot(h)

%%
% Here are all the local extrema, smooth and nonsmooth:
  extrema = roots(diff(h));
  hold on, plot(extrema,h(extrema),'.r')

%%
% Suppose we want to pick out the local extrema that are actually
% local minima.  We can do that by checking for the second
% derivative to be positive:

  h2 = diff(h,2);
  maxima = extrema(h2(extrema)>0);
  plot(maxima,h(maxima),'ok','markersize',12)

%% 3.4 Global extrema: max and min
% If "min" or "max" is applied to a single chebfun, it returns
% its global minimum or maximum.  For example:
  f = chebfun('1-x.^2/2');
  [min(f) max(f)]

%%
% The system computes such a result by checking the values of
% f at all endpoints and at zeros of the derivative.

%%
% As with standard Matlab, one can find the location of the
% extreme point by supplying two output arguments:

  [minval,minpos] = min(f)
%%
% Note that just one position is returned even though the
% minimum is attained at two points.  This is consistent
% with the behavior of standard Matlab.

%%
% This ability to do global 1D optimization in the chebfun
% system is rather remarkable.  Here is a nontrivial example.
  f = chebfun('sin(x)+sin(x.^2)',[0,15]);
  hold off, plot(f,'k')
%%
% The length of this chebfun is not as great as one might
% imagine:
  length(f)
%%
% Here are its global minimum and maximum:
  [minval,minpos] = min(f)
  [maxval,maxpos] = max(f)
  hold on
  plot(minpos,minval,'.b','markersize',30)
  plot(maxpos,maxval,'.r','markersize',30)

%% 3.5 norm(f,1) and norm(f,inf)
% The default, 2-norm form of the "norm" command was considered in Section 2.2.
% In standard Matlab one can also compute 1, infinity, and Frobenius norms
% with norm(f,1), norm(f,inf), and norm(f,'fro').  The first two of these
% have been overloaded in the chebfun system, and in both cases, rootfinding
% is part of the implementation.  The 1-norm norm(f,1) is the integral of 
% the absolute value, and the system computes this by adding up segments
% between zeros, at which abs(f) will typically have a discontinuous slope.
% The infinity-norm is computed from the formula
% norm(f,inf) = max(max(f),-min(f));

%%
% For example:
  f = chebfun('sin(x)',[103 103+4*pi]);
  norm(f,inf)
  norm(f,1)


%% 3.6 References
%
% [Battles 2006] Z. Battles, Numerical Linear Algebra for
% Continuous Functions, DPhil thesis, Oxford University
% Computing Laboratory, 2006.
%
% [Boyd 2002] J. A. Boyd, "Computing zeros on a real interval
% through Chebyshev expansion and polynomial rootfinding",
% SIAM Journal on Numerical Analysis 40 (2002), 1666-1682.
%
% [Good 1961] I. J. Good, "The colleague matrix, a Chebyshev
% analogue of the companion matrix", Quarterly Journal of 
% Mathematics 12 (1961), 61-68.
