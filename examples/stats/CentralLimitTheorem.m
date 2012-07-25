%% Central limit theorem
% Nick Trefethen, July 2012

%%
% (Chebfun example approx/CentralLimitTheorem.m)
% [Tags: #centrallimittheorem, #convolution, #CONV, #probability]

%%
% The central limit theorem is one of the most striking results
% in the theory of probability.  It says that if you take the mean of
% $n$ independent samples from any random variable, then as $n\to\infty$,
% the distribution of these means approaches a normal distribution, i.e.,
% a Gaussian or bell curve.
% For example, if you toss a coin $n$ times, the number of
% heads you get is given by the binomial distribution, and this approaches
% the bell curve.

%% 
% More specifically, let $X_1, \dots , X_n$ be independent samples
% from a distrubtion with mean $\mu$ and variance $\sigma^2<\infty$,
% and consider the sample mean
% $$ S_n = n^{-1} \sum_{k=1}^n X_n . $$
% The law of large numbers asserts that $S_n \to  \mu$ as
% almost surely as $n\to\infty$.
% The central limit theorem asserts that the random variables
% $\sqrt n (S_n-\mu)$ converge in distribution to the normal
% distribution $N(0,\sigma^2)$.  Details are given in many
% textbooks of probability and statistics.

%%
% The Chebfun CONV command makes it possible to illustrate the
% central limit theorem for general distributions, because the probability
% distribution associated with the sum of random variables is given
% by a convolution.  For example, consider this triangular probability distribution:
X = chebfun(0,'(4/3+x)/2',0,[-3 -4/3 2/3 3]);
LW = 'linewidth'; lw = 1.6; ax = [-3 3 -.2 1.2];
hold off, plot(X,LW,lw,'jumpline','b'), axis(ax), grid on
FS = 'fontsize'; fs = 12;
title('Distribution of X',FS,fs)

%%
% $X$ has mean zero and variance $2/9$:
t = chebfun('t',[-3 3]);
mu = sum(t.*X)
variance = sum(t.^2.*X)

%% 
% Let us superimpose on the plot the normal distribution of
% this mean and variance:
sigma = sqrt(variance);
gauss = @(sigma) chebfun(@(t) exp(-.5*(t/sigma).^2)/(sigma*sqrt(2*pi)),[-3 3]);;
hold on, plot(gauss(sigma),'r',LW,lw)
title('Distribution of X compared with normal distribution',FS,fs)

%%
% Here is the distribution for the sum of two copies of $X$, renormalized
% so that the variance is again $2/9$:
X2 = conv(X,X);
S2 = newdomain(sqrt(2)*X2,[-3,3]*sqrt(2));
hold off, plot(S2,LW,lw,'jumpline','b'), axis(ax), grid on
title('Renormalized distribution of (X+X)/2',FS,fs)
hold on, plot(gauss(sigma),'r',LW,lw)

%%
% And here we have the renormalized sum of three:
X3 = conv(X2,X);
S3 = newdomain(sqrt(3)*X3,[-3,3]*sqrt(3));
hold off, plot(S3,LW,lw,'jumpline','b'), axis(ax), grid on
title('Renormalized distribution of (X+X+X)/3',FS,fs)
hold on, plot(gauss(sigma),'r',LW,lw)

%%
% ... and of four:
X4 = conv(X3,X);
S4 = newdomain(sqrt(4)*X4,[-3,3]*sqrt(4));
hold off, plot(S4,LW,lw,'jumpline','b'), axis(ax), grid on
title('Renormalized distribution of (X+X+X+X)/3',FS,fs)
hold on, plot(gauss(sigma),'r',LW,lw)

%%
% Convolutions like these appear in another Chebfun Example, called
% "B-splines and convolutions" (approx/BSplineConv).  The only difference
% is that in that case we start with a uniform rather than triangular
% distribution.

