%% CHEBFUN GUIDE 8: CHEBFUN PREFERENCES
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
% In this section of the Chebfun Guide we explore these
% adjustable preferences, showing how special effects can be achieved
% by modifying them.  Besides showing off some useful techniques, this
% review will also serve to deepen the user's understanding of the system by poking
% about a bit at its edges.

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
% succession of pieces, each 100 times smaller than the next:
  
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
% the parameter splitdegree determines where this will happen.  With the factory
% value splitdegree=128, splitting will take place if a polynomial of degree 128
% proves insufficient to resolve a fun. 
% Let us confirm for the chebfun f constructed a moment ago that
% the degrees of the individual funs are all less or equal than 128:

  f.funs

%%
% Alternatively, suppose we wish to allow individual funs to
% have degree up to 512.  We can do that like this:

  chebfunpref('splitdegree',512);
  f = chebfun(ff);
  length(f)
  format short, f.ends
  f.funs

%% 8.5  chebfunpref('maxdegree'): maximum degree
% As just mentioned, in
% splitting off mode, the constructor tries to make a global chebfun
% from the given string or anonymous function.  For a function like
% abs(x) or sign(x), this will typically not be possible and we must give up somewhere.
% The parameter maxdegree, set to 2^16 in the factory, determines this giving-up point.

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
% exactly 50 points.  On the other hand we could also change the default maximum
% to this number (or more precisely the default degree to one less than this number),
% and then there would be a warning message:

  chebfunpref('maxdegree',49);
  f = chebfun('sign(x)');

%%
% Perhaps more often one might wish to adjust this preference to enable use of
% especially high degrees.  On the machines of 2008, the chebfun system is perfectly
% capable of working with polynomials of degrees in the millions.
% The function abs(x)^(3/2) on [-1,1] provides a nice example, for it is
% smooth enough to be resolved by a global polynomial, provided it is
% of rather high degree:

  chebfunpref('maxdegree',1e6);
  tic
  f = chebfun('abs(x).^1.5');
  lengthf = length(f)
  format long, sumf = sum(f)
  plot(f)
  toc

%% 8.6  chebfunpref('minsamples'): minimum number of sample points
% At the other end of the spectrum, the parameter minsamples determines the minimum
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
% If we increase minsamples, the correct chebfun is found:

  chebfunpref('minsamples',17)
  f = chebfun('-x -x.^2 + exp(-(30*(x-.5)).^4)');
  length(f)
  plot(f)

%%
% Incidentally, if the value of minsamples specified is not one greater
% than a power of 2, it is rounded up to the next such value.
% So chebfunpref('minsamples',10) would give the same result as
% chebfunpref('minsamples',17).

%%
% The default minsamples=9 was chosen as a good compromise between efficiency
% and reliability.  In practice it rarely seems to fail, but perhaps
% it is most vulnerable when applied in splitting on mode
% to functions with discontinuities.  For example, the following
% chebfun is missing some pieces near the right boundary:

  chebfunpref('factory')
  splitting on
  f = chebfun('round(.55*sin(x+x.^2))',[0 10]);
  plot(f), axis off

%%
% Increasing minsamples fills in the missing pieces:

  chebfunpref('minsamples',17)
  f = chebfun('round(.55*sin(x+x.^2))',[0 10]);
  plot(f), axis off
    
%% 8.7  chebfunpref('resampling'): resampling off and on
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
% the command resampling off:

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
% Users dealing with challenging functions may wish to try "resampling off" in hopes
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

%% 8.8 chebfunpref('eps'): chebfun constructor tolerance
% An experimental feature has been included in recent versions of the chebfun
% system: the ability to weaken the tolerance in constructing a chebfun.
% The chebfunpref parameter eps is set by default to machine precision,
% i.e., Matlab's eps value 2.2204e-16.  However, one can weaken this with
% a command like chebfunpref('eps',1e-6).
% After further development we
% intend to discuss this in a separate section of this Guide.  We recommend
% that users not change eps unless they are having real problem with standard
% precision.  Also we ask: if you have interesting experience with the eps parameter,
% please get in touch with us at chebfun@comlab.ox.ac.uk 
