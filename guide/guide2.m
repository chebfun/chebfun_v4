%% CHEBFUN GUIDE 2: INTEGRATION AND DIFFERENTIATION
% Lloyd N. Trefethen, April 2008

%% 2.1 sum
% We have seen that the "sum" command returns
% the definite integral of a chebfun over its range of
% definition.  The integral is calculated by an FFT-based variant
% of Clenshaw-Curtis quadrature, as described first in [Gentleman 1972].
% This formula is applied on each fun (i.e., each smooth piece of
% the chebfun), and then the results are added up.

%%
% Here is an example whose answer is known exactly:
  f = chebfun('log(1+tan(x))',[0 pi/4]);
  I = sum(f)
  Iexact = pi*log(2)/8

%%
% Here is an example whose answer is not known exactly, given
% as the first example in the section "Numerical Mathematics in
% Mathematica" in The Mathematica Book [Wolfram 2003].

  f = chebfun('sin(sin(x))',[0 1]);
  sum(f)

%%
% All these digits match the result 0.4306061031206906049...
% reported by Mathematica.

%%
% Here is another example:
  t = chebfun('t',[0,1]);
  f = 2*exp(-t.^2)/sqrt(pi);
  I = sum(f)
%%
% The reader may recognize this as the integral that defines
% the error function evaluated at t=1:
  Iexact = erf(1)
%%
% It is interesting to compare the times involved in evaluating
% this number in various ways.  Matlab's specialized erf code is
% the fastest:
  tic, erf(1), toc
%%
% Using Matlab's standard numerical quadrature command
% with a tolerance of 1e-14 is much slower:
  f = @(t) 2*exp(-t.^2)/sqrt(pi);
  tic, quad(f,0,1,1e-14), toc
%%
% The timing for chebfuns comes out in-between:
  tic, sum(chebfun(f,[0,1])), toc
%%
% Here is a similar comparison for a function that is much
% more difficult, because of the absolute value, which leads to
% a chebfun consisting of a number of funs.
  f = chebfun(@(x) abs(besselj(0,x)),[0 20]);
  plot(f)

%%
% The integral comes out successfully.  This demonstration
% computes the chebfun again in order to give meaningful timing.
  tic
  f = chebfun(@(x) abs(besselj(0,x)),[0 20]);
  sum(f)
  toc
%%
% Here is the performance for Matlab's standard quadrature code "quad"
% and for its alternative code "quadl":
  f = @(x) abs(besselj(0,x));
  tic, quad(f,0,20,1e-14), toc
  tic, quadl(f,0,20,1e-14), toc
%%
% This last example highlights the piecewise-smooth aspect
% of chebfun integration.  Here is another more contrived
% example of a piecewise smooth problem.
  x = chebfun('x');
  f = sech(3*sin(10*x));
  g = sin(9*x);
  h = min(f,g);
  plot(h)
%%
% The chebfun system readily finds the integral:
  tic, sum(h), toc

%%
% For a final example of a definite integral we turn to an integrand
% given as example F21F in [Kahaner 1971].  We treat it first with splitting off:

  splitting off
  x = chebfun('x',[0 1]);
  f = sech(10*(x-0.2)).^2 + sech(100*(x-0.4)).^4 + sech(1000*(x-0.6)).^6;

%%
% The function has three spikes, each ten times narrower than the last:
  plot(f)

%%
% The length of the global polynomial representation is accordingly quite
% large, but the integral comes out correct to full precision:

  length(f)
  sum(f)

%%
% With splitting on, we get a much shorter chebfun since the narrow
% spike is isolated; and the integral is the same:

  splitting on
  f = sech(10*(x-0.2)).^2 + sech(100*(x-0.4)).^4 + sech(1000*(x-0.6)).^6;
  length(f)
  sum(f)


%% 2.2 norm, mean, std, var
% An important special case of an integral is the "norm" command,
% which for a chebfun by default returns the 2-norm, i.e., the square root
% of the integral of the square of the absolute value over the
% region of definition.  Here is a well-known example:
  norm(chebfun('sin(pi*theta)'))

%%
% If we take the sign of the sine, the norm increases to sqrt(2):
  norm(chebfun('sign(sin(pi*theta))'))

%%
% Here is a function that is infinitely differentiable
% but not analytic.  The shift by 1e-30 is introduced
% to avoid spurious difficulties with evaluation of exp(-1/0).
  f = chebfun('exp(-1./sin(10*x+1e-30).^2)');
  plot(f)

%%
% Here are the norms of f and its tenth power:
  norm(f), norm(f.^10)

%% 2.3 cumsum
% In Matlab, "cumsum" gives the cumulative sum of a 
% vector,
  v = [1 2 3 5]
  cumsum(v)
%%
% The continuous analogue of this operation is
% indefinite integration.
% If f is a fun of length n, then cumsum(f) is a fun of length
% n+1.  For a chebfun consisting
% of several funs, the integration is performed on each piece.

%%
% For example, returning to an integral computed above,
% we can make our own error function like this: 
  t = chebfun('t',[-5 5]);
  f = 2*exp(-t.^2)/sqrt(pi);
  fint = cumsum(f);
  plot(fint,'m')
  ylim([-0.2 2.2]), grid on

%%
% The default indefinite integral takes the value 0 at the
% left endpoint, but in this case we would like 0 to appear
% at t=0:

  fint = fint - fint(0);
  plot(fint,'m')
  ylim([-1.2 1.2]), grid on

%%
% The agreement with the built-in error function is convincing:

  [fint((1:5)') erf((1:5)')]

%% 
% Here is the integral of a oscillatory step function:

  x = chebfun('x',[0 6]);
  f = x.*sign(sin(x.^2)); subplot(1,2,1), plot(f)
  g = cumsum(f); subplot(1,2,2), plot(g,'m')

%%
% And here is an example from number theory.  The logarithmic
% integral, Li(x), is the indefinite integral from 0 to x of
% 1/log(s).  It is an approximation to pi(x), the number of
% primes less than or equal to x.  To avoid the singularity at
% x=0 we begin our integral at the point mu = 1.045... where
% Li(x) is zero, known as Soldner's constant.
% The test value Li(2) is correct except in the last digit:

  mu = 1.45136923488338105;   % Soldner's constant
  xmax = 400;
  Li = cumsum(chebfun(@(x) 1./log(x),[mu xmax]));
  lengthLi = length(Li)
  Li2 = Li(2)

%%
% (The chebfun system has no trouble if xmax is increased
% to 10^5 or 10^10.)  Here is a plot comparing Li(x) with pi(x):
  close, plot(Li,'m')
  p = primes(xmax);
  hold on, plot(p,1:length(p),'.k')

%%
% The Prime Number Theorem implies that pi(x) ~ Li(x) as x -> infinity.
% Littlewood proved in 1914 that although Li(x) is greater than
% pi(x) at first, the two curves eventually cross each other infinitely often.
% (It is thought that the first crossing may occur around x = 1e316.)

%%
% The "mean", "std", and "var" commands have also been overloaded
% for chebfuns and are based on integrals.  For example

  mean(chebfun('cos(x).^2',[0,10*pi]))

%% 2.4 diff
% In Matlab, "diff" gives finite differences of a vector:
  v = [1 2 3 5]
  diff(v)
%%
% The continuous analogue of this operation is
% differentiation.  For example:
  f = chebfun('cos(pi*x)',[0 20]);
  fprime = diff(f);
  hold off, plot(f)
  hold on, plot(fprime,'r')
%%
% If the derivative is computed of a function with a jump, then
% a delta function is introduced, which shows up as an arrow in
% in the "plot" command.  Consider for example this
% function defined piecewise:

  f = chebfun('x.^2',1,'4-x','4./x',0:4);
  hold off, plot(f)

%%
% Here is the derivative:
  fprime = diff(f);
  plot(fprime,'r')

%%
% The first segment of f' is linear, since f is quadratic here.
% Then comes a segment with f' = 0, since f is constant.
% And the end of this second segment appears
% a delta function of amplitude 1, corresponding to
% the jump of f by 1.  The third segment has constant
% value f' = -1. Finally another delta function, this time with
% amplitude 1/3, takes us to the final segment.

%%
% Thanks to the delta functions, cumsum and diff are essentially
% inverse operations.  It is no surprise that differentiating
% an indefinite integral returns us to the original function:

  norm(f-diff(cumsum(f)))

%%
% More surprising is that integrating a derivative does the same, so
% long as we add in the value at the left endpoint:

  [left,right] = domain(f);
  f2 = f(left) + cumsum(diff(f));
  norm(f-f2)

%%
% Multiple derivatives can be obtained by adding a second
% argument to "diff".  Thus for example,
  f = chebfun('1./(1+x.^2)');
  g = diff(f,4); plot(g)

%%
% However, one should be cautious about the potential loss of information
% in repeated differentiation.  For example, if we evaluate this fourth
% derivative at x=0 we get an answer that matches the correct
% value 24 only to 12 places:

  g(0)

%%
% For a more extreme example, suppose we define a chebfun
% for exp(x) on [-1,1]:

  f = chebfun('exp(x)');
  length(f)

%%
% Since f is a polynomial of low degree, it cannot help but
% lose information rather fast as we differentiate, and 14
% differentiations eliminate the function entirely.

  for j = 0:length(f)
    fprintf('%6d %19.12f\n', j,f(1))
    f = diff(f);
  end

%%
% Is such behavior "wrong"?  We shall discuss this question more later.
% In short, the chebfun system is behaving correctly in the sense
% mentioned in the second paragraph of Section 1.1: the 
% operations are individually stable in that each differentiation returns
% the exact derivative of a function very close to the right one.
% The trouble is that the errors in these stable operations accumulate
% exponentially as successive derivatives are taken.  This is
% an example of the instability of a chebfun algorithm, analogous to
% the familiar phenomenon of instability of certain ordinary numerical
% algorithms.

%% 2.5 References
%
% [Gentleman 1972] W. M. Gentleman, "Implementing
% Clenshaw-Curtis quadrature I and II", Journal of
% the ACM 15 (1972), 337-346 and 353.
%
% [Kahaner 1971] D. K. Kahaner, "Comparison of numerical quadrature
% formulas", in J. R. Rice, ed., Mathematical Software, Academic Press, 1971, 229-259.
%
% [Wolfram 2003] S. Wolfram, The Mathematica Book, 5th ed., 
% Wolfram Media, 2003.
