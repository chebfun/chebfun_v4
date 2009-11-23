%% CHEBFUN GUIDE 9: INFINITE INTERVALS, INFINITE FUNCTION VALUES, AND SINGULARITIES
% Lloyd N. Trefethen, November 2009

%%
% This chapter presents some new features of
% the chebfun system that are less robust than what is
% described in the first eight chapters.  With classic bounded
% chebfuns on a bounded interval [a,b], you can do amazingly
% complicated things often without encountering any difficulties.
% Now we are going to let the intervals and the functions
% diverge to infinity -- but please
% lower your expectations!  Partly because the software is new
% and experimental, and partly for good mathematical reasons,
% one cannot expect anywhere
% near the same reliability with these new features.

%% 9.1 Infinite intervals
% If a function converges reasonably rapidly to a constant at infinity,
% you can define a corresponding chebfun.  Here are a couple of
% examples on [0,inf].  First we plot a function and find its maximum:
f = chebfun('0.75 + sin(10*x)./exp(x)',[0 inf]);
plot(f)
maxf = max(f)

%%
% Next we plot another function and integrate it from 0 to inf:
g = chebfun('1./(gamma(x+1))',[0 inf]);
sumg = sum(g)
plot(g,'r')

%%
% Where do f and g intersect?  We can find out using roots:
plot(f), hold on, plot(g,'r')
r = roots(f-g)
plot(r,f(r),'.k')

%%
% Here's an example on [-inf,inf] with a calculation of
% the location and value of the minimum:
g = chebfun(@(x) tanh(x-1),[-inf inf]);
g = abs(g-1/3);
clf, plot(g)
[minval,minpos] = min(g)

%%
% Notice that a function on an infinite domain is by default plotted
% on an interval like [0,10] or [-10,10].  You can use an extra
% 'interval' flag to plot
% on other intervals, as shown by this example of a function
% of small norm whose largest values are near x=30:
hh = @(x) cos(x)./(1e5+(x-30).^6);
h = chebfun(hh,[0 inf]);
plot(h,'interval',[0 100])
normh = norm(h)
%%
% Chebfuns provide a convenient tool for the
% numerical evaluation of integrals over infinite domains:
g = chebfun('(2/sqrt(pi))*exp(-x.^2)',[0 inf])
sumg = sum(g)

%%
% The cumsum operator applied to this integrand gives us the error function,
% which matches Matlab's erf function well:
errorfun = cumsum(g)
disp('          erf               errorfun')
for n = 1:6, disp([erf(n) errorfun(n)]), end

%%
% One should be cautious in evaluating integrals over infinite intervals,
% however, for as mentioned in Section 1.5, the accuracy
% is sometimes disappointing,
% especially for functions that do not decay very quickly:
sum(chebfun('(1/pi)./(1+s.^2)',[-inf inf]))

%%
% Here's an example of a function that is too wiggly to be
% fully resolved:
sinc = chebfun('sin(pi*x)./(pi*x)',[-inf inf]);
plot(sinc,'m','interval',[-10 10])

%%
% The exact 2-norm is 1:
norm(sinc)


%%
% Chebfun's capability of handling infinite intervals was introduced by
% Rodrigo Platte in 2008-09.  The basis of these computations is a change
% of variables, or mapping, which reduces the infinite interval to
% [-1,1].  Let's take a look at what is going on in the case
% of the function g just constructed.  We'll do this by digging inside
% the chebfun system a bit -- with a warning that the details
% of these inner workings are by no means fixed, but may differ
% from one chebfun version to the next.

%%
% First we look at the different fields that make up a chebfun:
struct(g)

%%
% The first field, funs,
% indicates in this case that g consists of a single fun, that is, it
% is not split into pieces.  We can look at that fun like this:
f = g.funs;
struct(f)

%%
% The crucial item here is map, which in turn has a number of fields:
m = f.map

%%
% What's going on here is the use of a rational mapping from the
% y variable in [-1,1] to the x variable in the infinite domain.
% The forward map is a Matlab anonymous function,
m.for

%%
% The inverse map is another anonymous function,
m.inv

%%
% The derivative of the forward map is used in the calculation
% of integrals and derivatives:
m.der

%%
% Matlab's anonymous functions don't make the values of the
% parameters a and s visible, though as it happens these numbers can be found
% as the first and last entries of the par field,
m.par

%%
% The use of mappings to reduce an unbounded domain to a bounded one
% is an idea that has been employed many times
% over the years.  One of the references we have benefitted especially from, which
% also contains pointers to other works in this area, is the book [Boyd 2001].

%% 9.2 Infinite function values and singularities
% Chebfun can handle certain "vertical" infinities as well as
% "horizontal" ones -- that is, functions that blow up according
% to an algebraic power.  If you know the nature of the blowup,
% it is a good idea to specify it using the 'exps' flag.
% For example, here's a function with a pole at 0.  We can use
% 'exps' to tell the constructor that the function looks like x^(-1)
% at the left endpoint and x^0 (i.e., smooth) at the right
% endpoint.
f = chebfun('sin(50*x) + 1./x',[0 4],'exps',{-1,0});
plot(f), ylim([-5 30])

%%
% Here's a function with inverse square root singularities at each end:
w = chebfun('(2/pi)./(sqrt(1-x.^2))','exps',{-.5 -.5});
plot(w,'m'), ylim([0 10])

%%
% The integral of this function is 2:
sum(w)

%%
% We pick this example because
% Chebyshev polynomials are the orthogonal polynomials with respect
% to this weight function, and Chebyshev coefficients are defined by
% inner products against Chebyshev polynomials with respect to this
% weight.  For example, here we compute inner products of x^4 + x^5
% against the Chebyshev polynomials T0,...,T5.  (The integrals
% in these inner products
% are calculated by Gauss-Jacobi quadrature using methods implemented by
% Nick Hale; for more on this subject see the command jacpts.)
x = chebfun('x');
T = chebpoly(0:5)';
f = x.^4 + x.^5;
chebcoeffs1 = T*(w.*f)

%%
% Here for comparison are the Chebyshev coefficients as obtained
% from chebpoly:
chebcoeffs2 = flipud(chebpoly(f)')

%%
% Notice the excellent agreement except for coefficient a0.  As mentioned
% in Section 4.1, in this special case
% the result from the inner product must be multiplied by 1/2.

%% 
% You can specify singularities for functions that don't blow up, too.
% For example, suppose we want to work with sqrt(x) on the interval
% [0,2].  A first try fails completely:
ff = @(x) sqrt(x.*exp(x));
d = domain(0,2);
f = chebfun(ff,d)

%%
% We could use splitting on and resolve the function by many
% pieces, as illustrated in Section ?.?:
f = chebfun(ff,d,'splitting','on')

%%
% A much better representation, however, is constructed if we
% tell the system about the singularity at x=0:
f = chebfun(ff,d,'exps',{.5 0})
plot(f)

%%
% Under certain circumstances chebfun will introduce singularities
% like this of its own accord.  For example, just as abs(f) introduces
% breakpoints at roots of f, sqrt(abs(f)) introduces breakpoints and
% also singularities at such roots:
theta = chebfun('t',[0,4*pi]);
f = sqrt(abs(sin(theta)));
plot(f)
sumf = sum(f)

%%
% (But why can't I do min(f,.5)?)

%%
% If you have a function that blows up but you don't know the
% nature of the singularities, chebfun will try to figure them
% out automatically.  Here's an example

%%
f = chebfun('x.*(1+x).^(-exp(1)).*(1-x).^(-pi)')

%%
% Notice that the 'exps' field shows values close
% to -e and -pi, as is confirmed by looking
% at the numbers to higher precision:
f.funs.exps

%%
% With splitting on, we can even find blowups in the middle
% of a domain:
f = chebfun('tan(x)',[0 10],'splitting','on');
plot(f), ylim([-20 20])

%%
% Alas I'm not sure how well this is working!  Look here:
f(3)
tan(3)

%%
% Here's another one that puzzles me:
r = roots(f-1)

%%
% This one on the other hand doesn't surprise me:
w1 = w+1;

%%
% The treatment of blowups in the chebfun system
% was initiated by Mark Richardson in an MSc thesis at
% Oxford [Richardson 2009], then further developed by
% Richardson in collaboration with Rodrigo Platte and
% Nick Hale.  This is very much a work in 
% progress and we hope to make it more reliable in future
% releases.

%% 9.3 Another approach to singularities

%% 9.4 References
%
% [Boyd 2001] J. P. Boyd, Chebyshev and Fourier Spectral Methods,
% 2nd ed., Dover, 2001.
%
% [Richardson 2009] M. Richardson, Approximating Divergent
% Functions in the Chebfun System, thesis, MSc
% in Mathematical Modelling and Scientific Computing,
% Oxford University, 2009.
% 
