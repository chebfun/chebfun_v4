%% Fast convolution and the Weierstrass Approximation Theorem
% Nick Trefethen, 22nd January 2014

%%
% (Chebfun Example approx/FastConvWeierstrass.m)
% [Tags: CONV, convolution, Weierstrass]

%%
% Every chapter of Approximation Theory and Approximation Practice [2] is an
% executable Matlab M-file, available online at www.maths.ox.ac.uk/chebfun/ATAP.
% If you apply the Matlab publish command to chap1.m, chap2.m, and so on, the
% comment lines turn into LaTeX text and the executable lines turn into executed
% demonstrations using Chebfun.

%%
% The big problem in writing the book was Chapter 6.  Most of the chapters
% execute in a few seconds, but Chapter 6 used to take three minutes on my
% machine -- and it only runs that fast because I trimmed parameters all over
% the place to speed it up. I hate that!  (For details of why I hate it, see
% [2].)

%%
% Here in January 2014, the situation has changed completely. Hale and Townsend
% have developed and implemented a new algorithm that speeds up chapter 6, on my
% computer, by a factor of 65 [1], from minutes to seconds.  It's an astonishing
% difference.

%%
% Here is the computation in question.  Recall that the Weierstrass
% Approximation Theorem asserts that any continuous function on $[-1,1]$ can be
% approximated arbitrarily closely by polynomials. In my book, I outline
% Weierstrass's original proof from 1885 [4]. Start with a challenging function
% $f$, like this one.
tic
f = chebfun(@(x) sin(1./x).*sin(1./sin(1./x)),[.07 .4],30000);
plot(f), xlim([.07 .4]), FS = 'fontsize';
title('A continuous function that is far from smooth',FS,9)

%%
% Actually we want the function to be zero at both ends, so for simplicity we
% restrict our attention to a close-up of $f$:
a = 0.2885554757; b = 0.3549060246;
f2 = chebfun(@(x) sin(1./x).*sin(1./sin(1./x)),[a,b],2000);
plot(f2), xlim([a b]), title('Close-up',FS,9)

%%
% Now construct a narrow Gaussian with integral 1 corresponding to a small time
% parameter, say $t = 1e-7$:
t = 1e-7;
phi = chebfun(@(x) exp(-x.^2/(4*t))/sqrt(4*pi*t),.003*[-1 1]);
plot(phi), xlim(.035*[-1 1])
title('A narrow Gaussian kernel',FS,9)

%%
% If we convolve the Gaussian with the wiggly function, this is what we get:
f3 = conv(f2,phi);
plot(f3), xlim([a-.003,b+.003])
title('Convolution of the two',FS,9)

%%
% We can interpret this function as the function that results at time $t=1e-7$
% if the heat equation $u_t = u_{xx}$ is applied to the initial data $f$.
% Notice that the high wave numbers are attenuated while the low wave numbers
% are little changed.

%%
% This gives us a proof of Weierstrass's theorem, as follows. It can be shown
% that as $t$ shrinks to zero, the smoothed function approaches the wiggly one,
% for _any_ $f$, so long as it is continuous.  On the other hand for any $t>0$,
% the smoothed function is entire, i.e., analytic in the complex plane.  That
% means the smoothed function can be approximated arbitrarily closely by
% polynomial truncations of its Taylor series.  QED!

%%
% The number below shows how long this computation now takes. If only Chebfun
% had had the Hale-Townsend algorithm when I wrote the book!
toc

%%
% References:
%
% [1] N. Hale and A. Townsend, Convolution of compactly supported functions, in
% preparation.
%
% [2] L. N. Trefethen, Ten Digit Algorithms, unpublished essay available at
% http://people.maths.ox.ac.uk/trefethen/publication/PDF/2005_114.pdf.
%
% [3] L. N. Trefethen, Approximation Theory and Approximation Practice, SIAM,
% 2013.
%
% [4] K. Weierstrass, Über die analytische Darstellbarkeit sogenannter
% willkürlicher Functionen einer reellen Veränderlichen, Sitzungsberichte
% der Akademie zu Berlin, 633--639 and 789--805, 1885.

