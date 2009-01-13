%% CHEBFUN GUIDE 8: CHEBFUN PREFERENCES AND DIRTY TRICKS
% Lloyd N. Trefethen, January 2009

%% 8.1  Introduction
% Like any software system, the chebfun system is based on certain
% design decisions.  Some of these are fixed, like the principle
% of representing functions by Chebyshev expansions.  Others are adjustable,
% like the maximum number of times a function will be sampled before the
% system gives up trying to resolve it to machine precision.  A starting point in
% exploring these matters is to type the command help chebfunpref.
% (For chebops, there is help cheboppref.)
% Or more simply, we can execute chebfunpref itself.  Here we execute it with
% the argument 'factory' to ensure that all preferences are set to their
% 'factory values':

  chebfunpref('factory')

%%
% In this section of the Chebfun Guide we shall explore some of
% these adjustable preferences, showing how special effects can be achieved
% by modifying them.  Besides showing off some useful techniques, this
% review will also serve to deepen the user's understanding of the system by poking
% about a bit at its edges.  At the end we'll take the process a little further
% and show some really sneaky tricks.

%%
% The preference "tol" will not be discussed here; it gets a chapter of
% its own.

%% 8.2  chebfunpref('domain'): the default domain
% Like Chebyshev polynomials themselves, chebfuns are defined by default
% on the domain [-1,1] if no other domain is specified.  However, this
% default choice of the default domain can be modified.  For example, we can work with
% trigonometric functions on [0,2pi] conveniently like this:

  chebfunpref('domain',[0 2*pi])
  f = chebfun(@(t) sin(19*t));
  g = chebfun(@(t) cos(20*t));
  plot(f,g), axis equal, axis off

%% 8.3  chebfunpref('splitting'): splitting off and splitting on
% The most important variable a user can control in using
% the chebfun system is the choice of
% splitting off or splitting on.  Splitting off is currently the factory default,
% though splitting on was the default in chebfun versions released in 2008.

%%
% In both splitting off and splitting on modes, a chebfun may consist of a
% number of pieces, called funs.  For example, even in splitting off mode,
% the following sequence makes a chebfun with four funs:

  chebfunpref('factory');
  x = chebfun(@(x) x);
  f = min(abs(x),exp(x)/6);
  format short, f.ends
  plot(f)

%%
% One breakpoint is introduced at x=0, where the
% constructor recognizes that abs(x) has a zero, and
% two more breakpoints are introduced at -0.1443 and at 0.2045,
% where the constructor recognizes that
% abs(x) and exp(x)/6 will intersect.

%%
% The difference between splitting off and splitting on pertains to additional
% breakpoints that may be introduced in the more basic chebfun construction process,
% when the constructor makes a chebfun solely by sampling point values.
% For example, suppose we try to make the same chebfun as above from scratch,
% by sampling an anonymous function, in splitting off mode.  We get a warning message:

  ff = @(x) min(abs(x),exp(x)/6);
  splitting off
  f = chebfun(ff);

%%
% In splitting on mode, chebfun's built-in edge detector quickly finds
% the singular points and introduces breakpoints there:
  splitting on
  f = chebfun(ff);
  f.ends

%%
% This example involves specific points of singularity, which the constructor
% has duly located.  In addition to this,
% in splitting on mode the constructor will subdivide intervals recursively
% at non-singular points when
% convergence is not taking place fast enough.  For example, with splitting off
% we cannot successfully construct a chebfun for the square root function on [0,1]:

  splitting off
  f = chebfun(@(x) sqrt(x),[0 1]);
  format long
  f((.1:.1:.5)'.^2)

%%
% With splitting on, however, all is well:

  splitting on
  f = chebfun(@(x) sqrt(x),[0 1]);
  length(f)
  f((.1:.1:.5)'.^2)

%%
% Inspection reveals that the system has broken the interval into a
% succession of pieces, each about 100 times smaller than the next:
  
  f.ends

%%
% In this example all but one of the subdivisions have occurred
% near an endpoint, for the edge detector has estimated that the difficulty
% of resolution lies there.  For other functions, however,
% splitting will take place at midpoints.  For example, here is a function
% that is complicated throughout [-1,1], especially for larger values of x.

  ff = @(x) sin(x).*tanh(3*exp(x).*sin(15*x));

%%
% With splitting off, it gets resolved by a global polynomial of rather high degree.

  splitting off
  f = chebfun(ff);
  length(f)
  plot(f)

%%
% With splitting on, the function is broken up into pieces, and there is some
% reduction in the overall length:

  splitting on
  f = chebfun(ff);
  length(f)
  format short, f.ends

%%
% When should one use splitting off, and when splitting on?  If the goal
% is simply to represent complicated functions, especially when they are
% more complicated in some regions than others, splitting on has its advantages.
% An example is given by the function above posed on [-3,3] instead of [-1,1].
% With splitting off, the global polynomial has degree in the tens of thousands:

  splitting off
  f3 = chebfun(ff,[-3 3]);
  length(f3)
  plot(f3)

%%
% With splitting on the representation is much more compact:

  splitting on
  f3 = chebfun(ff,[-3 3]);
  length(f3)

%%
% On the other hand, splitting off mode has its advantages too.  In particular,
% operations involving derivatives generally work better when functions
% are represented by global polynomials, and the chebop system for the most
% part requires this.  Also, for educational purposes,
% it is very convenient that the chebfun system can be used so easily
% to study the properties of pure polynomial representations.

%% 8.4  chebfunpref('splitdegree'): degree limit in splitting on mode
% When intervals are subdivided in splitting on mode, as just illustrated, 
% the parameter nsplit determines where this will happen.  With the factory
% value nsplit=129, splitting will take place if a polynomial of degree 128
% proves insufficient to resolve a fun. 
% Let us confirm for the chebfun f constructed a moment ago that
% the lengths of the individual funs are all less than 129:

  f.funs

%%
% Alternatively, suppose we wish to allow individual funs to
% have length up to 513.  We can do that like this:

  chebfunpref('splitdegree',513);
  f = chebfun(ff);
  length(f)
  format short, f.ends
  f.funs

%% 8.5  chebfunpef('maxdegree'): maximum number of points
% As just mentioned, in
% splitting off mode, the constructor tries to make a global chebfun
% from the given string or anonymous function.  For a function like
% abs(x) or sign(x), this will typically not be possible and we must give up somewhere.
% The parameter maxn, set to 2^16+1 in the factory, determines this giving-up point.

%%
% For example, here's what happens normally if we try to make a chebfun for sign(x).

  chebfunpref('factory');
  splitting off
  f = chebfun('sign(x)');

%%
% Suppose we wish to examine the interpolant to this function through 50 points
% instead of 65537.  One way is like this:

  f = chebfun('sign(x)',50);
  plot(f)

%%
% Notice that no warning message is produced since we have asked explicitly for
% exactly 50 points.  On the other hand we could also change the default maximum to this number,
% and then there would be a warning message:

  chebfunpef('maxdegree',50);
  f = chebfun('sign(x)');

%%
% Perhaps more often one might wish to adjust this preference to enable use of
% especially high degrees.  On the machines of 2008, the chebfun system is perfectly
% capable of working with polynomials of degrees in the millions.
% The function abs(x)^(3/2) on [-1,1] provides a nice example, for it is
% smooth enough to be resolved by a global polynomial, provided it is
% of rather high degree:

  chebfunpef('maxdegree',1e6);
  tic
  f = chebfun('abs(x).^1.5');
  lengthf = length(f)
  format long, sumf = sum(f)
  plot(f)
  toc

%% 8.6  chebfunpref('minn'): minimum number of points
% At the other end of the spectrum, the parameter minn determines the minimum
% number of points at which a function is sampled during the chebfun construction
% process, and the factory value of this parameter is 9.  This does not
% mean that all chebfuns have length at least 9.  For example, 
% if f is a cubic, then it will be sampled at 9 points, Chebyshev expansion
% coefficients will be computed, and 5 of these will be found to be of negligible
% size and discarded.  So the resulting chebfun is a cubic, even though
% the constructor never sampled at fewer than 9 points.

  chebfunpref('factory');
  f = chebfun('x.^3');
  lengthf = length(f)

%%
% More generally a function is sampled at 9, 17, 33,... points until a set of
% Chebyshev expansion coefficients are obtained with a tail judged to be
% negligible.

%% 
% Like any process based on sampling, this one can fail.
% For example, here is a success:

  splitting off
  f = chebfun('-x -x.^2 + exp(-(30*(x-.5)).^2)');
  length(f)
  plot(f)

%%
% But if we change the exponent to 4, we get a failure:

  f = chebfun('-x -x.^2 + exp(-(30*(x-.5)).^4)');
  length(f)
  plot(f)

%%
% What has happened can be explained as follows.   
% The function being sampled has a narrow spike near x = 0.5, and the closest
% grid points lie near 0.383 and 0.707.  In the case of the exponent 2, we
% note that at x=0.383, exp(-(30(x-.5)^2))=4.5e-6,
% which is large enough to be noticed by the chebfun constructor.
% On the other hand in the case of exponent 4, we have
% exp(-(30(x-.5)^4))=1.2e-66, which is far below machine precision.  So in the latter
% case the constructor thinks it has a quadratic and does not try a finer grid.

%%
% If we increase minn, the correct chebfun is found:

  chebfunpref('minn',17)
  f = chebfun('-x -x.^2 + exp(-(30*(x-.5)).^4)');
  length(f)
  plot(f)

%%
% Incidentally, if the value of minn specified is not one greater
% than a power of 2, it is rounded up to the next such value.
% So chebfunpref('minn',10) would give the same result as
% chebfunpref('minn',17).

%%
% The default minn=9 was chosen as a good compromise between efficiency
% and reliability.  In practice it rarely seems to fail, but perhaps
% it is most vulnerable when applied in splitting on mode
% to functions with discontinuities.  For example, the following
% chebfun is missing some pieces near the right boundary:

  chebfunpref('factory')
  splitting on
  f = chebfun('round(.55*sin(x+x.^2))',[0 10]);
  plot(f), axis off

%%
% Increasing minn fills in the missing pieces:

  chebfunpref('minn',17)
  f = chebfun('round(.55*sin(x+x.^2))',[0 10]);
  plot(f), axis off
    
%% 8.7  chebfunpref('resampling'): resampling off and resampling on
% We now turn to a chebfun preference with some rather deep significance, relating
% to the very idea of what it means to sample a function.

%%
% When a chebfun is constructed, a function is normally sampled at 9, 17, 33,...
% Chebyshev points until convergence is achieved.  Now Chebyshev grids are nested,
% so the 17-point grid, for example, only contains 8 points that are not in the
% 9-point grid.  It may seem obvious that the chebfun constructor should take advantage
% of this property and not recompute
% values that have already been computed.  By the time we get to 65 points, for example,
% it may seem obvious that
% we should have done 65 evaluations, not 9+17+33+65 = 114.  A factor of approximately 2
% would seem to be at stake.

%% 
% Nevertheless, the chebfun system DOES by default recompute values when
% the grid is refined, or as we say,
% resample.  Why?  Part of the reason is historical.
% The original version by Zachary Battles in 2002 resampled, and we never found a compelling
% reason to change this.  Although the speed difference can be a factor of 2 in certain
% circumstances, often it is a smaller factor.  For example, here is a chebfun constructed
% in the usual factory mode, corresponding to resampling on:

  chebfunpref('factory');
  splitting off
  tic, f = chebfun(@(x) sin(x),[0 2000]); toc
  length(f)

%%
% Now let us see what happens if we turn off resampling, so that previously
% computed values will be reused.  We can do this with
% the command resample off:

  resampling off
  chebfunpref

%%
% If we construct the same chebfun as before, we find that there is a little
% speedup, but it is not very great:

  tic, f = chebfun(@(x) sin(x),[0 2000]); toc
  length(f)

%%
% The reason there is so little improvement is that evaluating sin(x) is nearly as
% quick as the other operations involved.
% To see more of an effect, we need a function whose sample values take
% longer to compute.  The chebfun representation of sin(x) over this long interval
% is a good candidate,
% so let us try the same experiment as before, but now sampling
% f(x) rather than sin(x):

  resampling on
  tic, g = chebfun(@(x) f(x),[0 2000]); toc
  length(g)

%%

  resampling off
  tic, g = chebfun(@(x) f(x),[0 2000]); toc
  length(g)

%%
% Now we see a speedup by a factor closer to 2.
% Users dealing with challenging functions may wish to try "resample off" in hopes
% of obtaining a similar speedup.

%%
% The other reason why the chebfun system resamples is that this introduces 
% very interesting new possibilities.  What if the "function" being sampled is not
% actually a fixed function, but depends on the grid?  For example, consider this prescription:

  ff = @(x) length(x)*sin(2*x);

%%
% The values of f at any particular point will
% depend on the length of the vector in which it is embedded!
% What will happen if we try to make a chebfun?  The constructor tries
% the 9-point Chebyshev grid, then the 17-point grid, then the 33-point grid.  On
% the last of these it finds the Chebyshev coefficients are sufficiently small, and
% proceeds to truncate to length 18.
% We end up with a chebfun of length 18 that precisely matches the function 33sin(2x).

  resampling on
  f = chebfun(ff);
  length(f)
  max(f)
  plot(f,'.-')

%%
% This rather bizarre example tempts us to play further.
% What if we change length(x)*sin(2*x) to sin(length(x)*x)?
% Now there is no convergence, for no matter how fine the grid is, the
% function is underresolved.

  hh = @(x) sin(length(x)*x);
  h = chebfun(hh);

%%
% Here is an in-between case where convergence is achieved on the grid of length 65:

  kk = @(x) sin(length(x).^(2/3)*x);
  k = chebfun(kk);
  length(k)
  plot(k,'.-')

%%
% Are such curious effects of any use?  Yes indeed, they are
% at the heart of the chebop system.  When the chebop system solves a differential
% equation by a command like u = L\f, for example, the chebfun u is determined by
% a "sampling" process in which a matrix problem obtained by Chebyshev spectral discretization 
% is solved on grids of size 9, 17, and so on.  The matrices change with the grids, so the
% sample values for u are crucially grid-dependent.  Without resampling,
% chebops would not work.

%%
% Besides chebops, are there other practical uses of the chebfun resampling feature?
% We do not currently know the answer and would be pleased to hear from users who
% may have ideas.

%% 8.8  Point values of chebfuns
% Chebfuns can have discontinuities; an example is a chebfun made from sign(x).
% What values do they take at the breakpoints?  At each breakpoint of a chebfun,
% there is a fun on the left, a fun on the right, and a value in the middle, which
% may be arbitrary.

%%
% Here for example we construct a chebfun for sign(x) itself:

  splitting on
  f = chebfun(@(x) sign(x));

%%
% On the left, the values are all -1:

  format short
  f([-1 -0.01 -realmin])

%%
% On the right, they are all +1:

  f([realmin 0.01 1])

%%
% In the middle, the value is zero:

  f(0)

%%
% The chebfun constructor knows nothing about the sign function, and
% has determined all this just by sampling.  For a different function the
% value at the point of discontinuity might have come out otherwise, and for that
% matter, it can be subsequently changed:

  f(0) = 17;
  f([-1 -.01 -realmin 0 realmin .01 1])

%%
% The chebfun f is still well-defined, still with two funs,
% and various derived quantities take their appropriate values:

  sum(f), max(f)

%%

  norm(f), norm(f,inf)

%%
% (Thus max and norm( . ,inf) return the strict supremum of a function,
% not what analysts call the essential supremum.)
% This brings to mind a trick that proves convenient in some applications.
% We can take a point in the middle of a fun and change the value there:

  f(0.5) = 999;
  f(0:0.1:0.9)

%%
% What has happened here is that the system has introduced a breakpoint at 0.5
% to accommodate the new value, so now the chebfun has three funs:

  f.ends

%%
% We can also use the same syntax to introduce a breakpoint without a
% discontinuity.  For example, here we introduce a breakpoint at 0.25:

  f(0.25) = f(0.25);
  f.ends

%% 8.9  Subintervals with {} and concatenations with ;
% The chebfun system uses the curly brackets { and } in a variety of ways that
% may be confusing at first but are extraordinarily convenient.  These uses do not
% correspond to the usual Matlab uses of { and }, namely for cell arrays.  Actually
% they are closer to Matlab's [ and ].  The trouble is that in the chebfun system,
% one would really like [ and ] to have two different meanings.  For example, if f is
% a chebfun, then the expression
%
%                        f([1,5])
%
% returns the vector obtained by evaluating f at the points 1 and 5.
% Yet it would also be natural for it to return a chebfun corresponding to f evaluated
% on the interval [1,5].  Since the same syntax cannot have two different meanings, we
% write f{1,5} in the second case.

%%
% Our first example is of just this kind:

  f = chebfun('cos(x)',[0 100]);
  g = f{50,70};
  plot(g)

%%
% But one can do much more, playing tricks with { and } just as Matlab plays
% tricks with [ and ].  For example, here we replace one part of f by a multiple of itself
% and another by a constant:

  h = f;
  h{20,40} = 0.5*h{20,40};
  h{60,80} = 0.75;
  plot(h)

%%
% If the length of the interval on the left is not the same as that on 
% the right, then one is scaled to fit the other.  For example, here we put
% a copy of all of f inside the interval [40,80]:

  k = f;
  k{40,80} = 0.8*k;
  plot(k)

%%
% Just as { and } enable the extraction of subintervals, ; enables the concatenation of
% chebfuns.  For example, here is a chebfun obtained by concatenating two copies of k:

  kk = [k; k];
  plot(kk)

%%
% Further related objects can be constructed with the chebfun overload of
% the command repmat.

%%
% Here is an example involving quasimatrices:

  x = chebfun('x');
  A = [chebpoly(1) chebpoly(3) chebpoly(5)];
  A{0,0.5} = [x x.^3 x.^5];
  plot(A)

%%
% The plot looks like a picture of a rather arbitrary collection of functions, and
% so it is, but as always in the chebfun system, A is a precisely defined object with which
% we can calculate precisely.  For example, here are its singular values:

  format long
  svd(A)
