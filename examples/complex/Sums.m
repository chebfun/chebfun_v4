%% Sums of Infinite Series via Contour Integrals
% Mohsin Javed, 31st May 2013
 
%%
% (Chebfun example complex/sums.m)
% [Tags: #infinite series, #sums, #contour integrals, #pole, #poles, #residues, #residue]
LW = 'linewidth'; lw = 1.5; 
MS = 'markersize';
%% Introduction
% Methods of complex analysis, in particular
% contour integration, can be used to 
% evaluate infinite series. Let us consider
% an infinite series of the form
% $$ \sum_{k=-\infty}^{\infty}f(k). $$
% We assume that the series
% is convergent. We now introduce the
% function
% $$ S(z) = \pi \cot \pi z. $$
% This is a very special function---it 
% is meromorphic throughout the complex 
% plane, with 
% a pole at every integer. Furthermore, 
% the residue at each pole 
% is 1. Another important property of 
% this function is that it 
% remains bounded throughout the
% complex plane as long as we
% avoid the integers [1]. We now consider the 
% contour integral
% $$ \int_{\Gamma_N}\pi f(z) \cot(\pi z) dz, $$
% where $\Gamma_N$ is a rectangular contour
% passing through the points $\pm \left(N+1/2\right)$
% and the points $\pm i\left(N+1/2\right)$. If the function
% $f$ decays at an appropriate 
% rate then as we let $N \to \infty$, and 
% expand the contour in the complex plane,
% the above contour integral vanishes. However, 
% by the residue theorem, we have
% $$ 0 = \lim_{N \to \infty}\frac{1}{2\pi i}\int_{\Gamma_N}\pi f(z) \cot(\pi z) dz  = \sum_{k=-\infty}^{\infty}f(k) + \sum_{j} Res(f(z)S(z),z_j), $$
% where the points $z_j$ are the poles of the function $f$.
% In other words,
% $$ \sum_{k=-\infty}^{\infty}f(k) = -\sum_{j} Res(f(z)S(z),z_j). $$
%% The Basel Problem
% This problem concerns series representing 
% values of the zeta function at positive even 
% integers.
% $$ \zeta( 2k ) = \sum_{n=1}^{\infty} \frac{1}{n^{2k}}. $$
% For instance it is well known that $\zeta(2) = \pi^2/6$. 
% For a much more detailed account of the problem and its
% historical origins, see [2] or [3]. To solve this 
% problem, we can apply the result established in 
% the last section. We have $f(z) = 1/z^{2k}$ and therefore
% $$ \sum_{n=1}^{\infty}\frac{1}{n^{2k}} = -\frac{1}{2} Res(\frac{\pi}{z^{2k}} \cot( \pi z), 0). $$
% We can compute the above residue as a contour integral
% $$ Res(\frac{\pi}{z^{2k}} \cot( \pi z), 0) = \frac{1}{2\pi i} \int_{\Gamma_0}\frac{\pi}{z^{2k}} \cot(\pi z) dz, $$
% where $\Gamma_0$ is a contour enclosing the pole at the origin only.
 
%%
% This last integral can be easily evaluated in 
% Chebfun. Let us select a circular contour that 
% encolose the pole at the origin only. 
R = 0.5;
z = chebfun(@(t) R*exp(1i*t), [0, 2*pi] );
%%
% Let us first evaluate the famous series
% $$ \sum_{n=1}^{\infty} \frac{1}{n^2}. $$
% We set
f = 1./z.^2;
S = pi*cot(pi*z);
%%
% The residue at the origin 
% and hence the sum can now be 
% computed very easily:
s = -1/2*real(1/(2*pi*1i)*sum(f.*S.*diff(z)))
%%
% The exact sum is $\pi^2/6$. Let's compare
% our result.
s-pi^2/6
%%
% Similarly, we find that $\zeta(4)$
s = -1/2*real(1/(2*pi*1i)*sum(1./z.^4.*S.*diff(z)))
%% 
% The exact value is $\pi^4/90$. The error we commit is
s - pi^4/90
%%
% For $\zeta(6)$, we find
s = -1/2*real(1/(2*pi*1i)*sum(1./z.^6.*S.*diff(z)))
%% 
% The exact value is $\pi^6/945$ and the error is
s - pi^6/945
 
%%
% We can easily see the pattern: $\zeta(2k)$ is $\pi^{2k}$ times
% the inverse of an integer. However, it is known that
% this factor in general is a rational number and not
% always an inverse integer. Let's see if we can guess this 
% rational number for
% $$ \zeta(10) = \frac{\pi^{10}}{93335}. $$
q = -1/2*real(1/(2*pi*1i)*sum(1./z.^10.*S.*diff(z)))/pi^10
rats(q) 
%% Some Other Infinite Series
% The same technique can be used to 
% evaluate other kinds of infinite series as well. 
% For example, to evaluate the series
% $$ \sum_{n=-\infty, n \neq 0, -1}^{\infty}\frac{1}{n(n+1)}, $$
% we need to calculate the residues of 
% $$ f(z) = \frac{1}{z(z+1)} $$
% at $z=0$ and $z=-1$. 
% We can do this in one go by using a circular
% contour of radius $1$ centred at the point
% $z=-0.5$ which encloses both poles of $f$.
R = 1;
z = chebfun(@(t) -0.5 + R*exp(1i*t), [0, 2*pi] );
plot(z, LW, lw), hold on
plot(0,0, 'rx', MS, 10 ), plot(-1,0, 'rx', MS, 10 ), axis equal
xlim( [-2, 2] ), hold off
%%
% After selecting the contour, we now use the usual 
% formula.
S = pi*cot(pi*z);
f = 1./(z.*(z+1));
s = -real(1/(2*pi*1i)*sum(f.*S.*diff(z)))
%%
% The exact answer is $2$, as can be seen by 
% expanding the general term of the series in 
% a partial fraction and the observing 
% a telescopic cancellation.
s - 2
%%
% Another example is the series
% $$ \sum_{n=-\infty}^{\infty}\frac{1}{n^2+w^2}, $$
% where $w$ is a non-zero real number. The associated function 
% $f$ in this case has two poles
% at $z = \pm iw$. 
 
%%
% As a specific example, let us say $w=1$. Then the poles are 
% located at $z = \pm i$. We use two contours, enclosing
% a pole each. And these two contours can 
% be placed in a single chebfun.
w = 1;
R = w/2;
z1 = chebfun(@(t) 1i*w + R*exp(1i*t), [0, 2*pi] );
z2 = chebfun(@(t) -1i*w + R*exp(1i*t), [0, 2*pi] );
plot(z1, LW, lw), hold on, plot(1i*w, 'rx', MS, 10 )
plot(z2, LW, lw), plot(-1i*w, 'rx', MS, 10 ), axis equal
ylim( [-2*w, 2*w] ), hold off
%%
% The sum of the series is given by
s1 = -real(1/(2*pi*1i)*sum(1./(z1.^2+w^2).*pi.*cot(pi*z1).*diff(z1)));
s2 = -real(1/(2*pi*1i)*sum(1./(z2.^2+w^2).*pi.*cot(pi*z2).*diff(z2)));
s = s1 + s2
%%
% The exact answer in this case is $(\pi/w)\coth(\pi w)$.
s - pi/w*coth(pi*w)
%%
% We can solve the same problem using a single 
% contour as long as the contour encloses the 
% poles at $\pm i w$ and does not 
% enclose any of the integers. However, if
% our contour encloses some integers as 
% well, we will have to subtract off their contributions
% to get the true value of the sum.
% For example,
% if we form an elliptic contour as shown below,
% we get an additional contribution due to the 
% residue at the origin, which is just a term
% of the series corresponding to $n=0$.
a = 1/2; b = 2*w;
z = chebfun(@(t) a*cos(t) + 1i*b*sin(t), [0, 2*pi] );
plot(z, LW, lw), hold on, plot(1i*w, 'rx', MS, 10 )
plot(-1i*w, 'rx', MS, 10 ), plot(0,0, 'kx', MS, 10 ), axis equal
ylim( [-3*w, 3*w] ), hold off
%%
% To evaluate the sum, we subtract off this extra contribution from
% the contour integral and get the same result as before.
s = -real(1/(2*pi*1i)*sum(1./(z.^2+w^2).*pi.*cot(pi*z).*diff(z))) + 1/w^2
%%
% Henrici [4], requires
% us to show that
% $$ \sum_{n = -\infty}^{\infty}\frac{1}{(n-w)^2} = \left(\frac{\pi}{\sin(\pi w)} \right)^2, $$
% where $w$ is a non-integer complex number. The only
% pole of the associated function is at the point $z=w$. Let 
% us evaluate this sum for $w = 1.5$.
w = 1.5; 
R = .25;
z = chebfun(@(t) w + R*exp(1i*t), [0, 2*pi] );
plot(z, LW, lw), hold on, plot(w,0, 'rx', MS, 10 )
xlim([w-2, w+2]), axis equal, hold off
f = 1./(z-w).^2;
S = pi*cot(pi*z);
s = real( -1/(2*pi*1i)*sum( f.*S.*diff(z) ) )
%%
% Comparing with the exact sum:
s - (pi/sin(pi*w))^2
%% Alternating Infinite Series
% The same technique can be utilized to 
% evaluate sums whose terms alternate 
% in sign. However, instead of the 
% cotangent function, we now choose 
% the cosecant function which also 
% has poles at the integers but the 
% residues alternate in sign taking 
% the values $+1$ and 
% $-1$ [1]. For example, to find the sum 
% $$ \sum_{n=1}^{\infty} \frac{(-1)^n}{n^2} $$
% we can say
R = .5;
z = chebfun(@(t) R*exp(1i*t), [0, 2*pi] );
s = -1/2*real(1/(2*pi*1i)*sum(1./z.^2*pi.*csc(pi*z).*diff(z)))
%%
% Since the exact answer is $-\pi^2/12$, we
% can check the error.
s - (-pi^2/12)

%% References
% 
% [1] Saff, E. B. and Snider, A. D., Fundamentals of Complex Analysis,  
% Prentice-Hall, 2003.
%
% [2] The Basel Problem, http://en.wikipedia.org/wiki/Basel_problem
%
% [3] Dwilewicz and Minac, Values of Reimann zeta function at integers, http://www.mat.uab.cat/matmat/PDFv2009/v2009n06.pdf
%
% [4] Henrici, P., Applied and Computational Complex Analysis, Vol I,
% Example 2, p. 268, John Wiley and Sons, 1974.