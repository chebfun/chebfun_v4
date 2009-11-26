%% QUADPTS_DEMO - Computing quadrature nodes and weights with the chebfun system.
%
% This demo is designed to be used with the 
%     http://www.maths.ox.ac.uk/chebfun 
% chebfun system and compiled with 'publish' -- e.g. web(publish('quadpts_demo'))
%
% It demonstrates the collection of efficient routines within the
% chebfun system for computing the nodes and weights of Gauss-Legendre,
% Clenshaw-Curtis, Fejer, and Gauss-Jacobi quadratures.


%% Gauss-Legendre Quadrature

%%
% The chebfun system can efficiently compute Legendre points (the roots of
% Legendre polynomials), and the corresponding weights for Gauss-Legendre 
% quadrature in two ways. 

%%
% The first, typically used when N (the number of points to be computed) is 
% small uses a standard tridiagonal eigenvalue problem of Golub and Welsch [1].

N = 32;
x = legpts(N);
%%
% When N is large (say greater than 128), the fast algorithm [2] developed by
% Glaser et al is used. Although a little less accurate than 'GW', this
% algorithm has a complexity cost of only O(N), rather than O(N^3) for the 
% eigenvalue problem. (Type "help legpts" for more information).

N = 256;
x = legpts(N);
%%
% To see the difference in speeds, we could type

N = 128;
tic
[x w] = legpts(N,'GW');
toc

tic
[x w] = legpts(N,'Fast');
toc
%%
% Here the double output "[x w] = ..." will return also the weights needed
% for Gauss quadrature. 
%
% The difference in times becomes even more dramtic when N is made larger.

N = 512;
tic
[x w] = legpts(N,'GW');
toc

tic
[x w] = legpts(N,'Fast');
toc
%%
% The fast algorithm is still pretty quick, even when N is very large.

N = 100000;
tic
[x w] = legpts(N,'Fast');
toc
%%
% We could now compute the Gauss quadrature approximation to the integral
% of the following recursively defined function

% Eqn (1.0)
f = @(x) sin(pi*x);
s = f;
for j = 1:10;
    f = @(x) (3/4)*(1 - 2*f(x).^4);
    s = @(x) s(x) + f(x);
end
f = @(x) s(x);

%%
% over [-1,1] by

IGQ = w*f(x)
toc

%% Clenshaw-Curtis and Fejer Quadrature
% Of course, we could use the chebfun system itself to compute the same
% integral, using Clenshaw-Curtis [3] rather than Gauss quadrature.

tic
g = chebfun(f,'splitting','off')
ICC = sum(g)
toc

%%
% Chebfun allows us to plot the function easily
plot(g)
title('The recursive function in Eqn (1.0)');

%%
% We can check the accuracy of these computations by comparing their values

abs(IGQ-ICC)

%%
% or by plotting convergence as N is increased
NN = 32:32:2*length(g)/3;
errGQ = []; errCC = [];
for N = NN
    [x w] = legpts(N);
    errGQ = [errGQ ; abs(w*f(x)-ICC)];
    errCC = [errCC ; abs(sum(chebfun(f,N))-ICC)];
end
semilogy(NN, errGQ, 'b', NN, errCC, 'r');
legend('Gauss Quadrature','Clenshaw-Curtis via Chebfun')
title('Convergence of quadratures for recursive function Eqn (1.0)');

%% 
% Chebfun uses a fast algorithm involving the Fast Fourier Transform (FFT)
% to compute such integrals, but it also contains an implementation of
% Waldvogel's algorithm [4] for computing the weights explicitly for both
% Chebyshev points of the 2nd kind 

N = 1000;
[x w] = chebpts(N);
ICC = w*f(x)

%%
% or of the 1st kind (i.e. Fejer quadrature)

[x w] = chebpts(N,'1st');
IFQ = w*f(x)

%%
% Type "help chebpts" for more information.
    
%% Gauss-Jacobi Quadrature
% As of version 3.0, chebfun can also compute the nodes and weights for 
% Gauss-Jacobi quadrature; that is for integrals of the form
%   int_{-1}^{1} (1-x)^alpha * (1+x)^beta * f(x) dx
% where f is a smooth function on [−1, 1] and alpha, beta > −1.
%
% The routines used are generalisations of those used in legpts (for which
% alpha = beta = 0), and are also derived by [1] and [2].

%%
% For example, one could compute the integral of 
% sqrt(1-x)*f(x)/sqrt(1+x) over [-1,1] (with f as in eqn (1.0)) by the
% following;

for N = 100:100:700
    [x w] = jacpts(N,.5,-.5);
    I = w*f(x)
end

%%
% Type "help jacpts" for more information.


%% References
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.
%
%  Copyright 2009 by The Chebfun Team. 
%
%  References:
%   [1] G. H. Golub and J. A. Welsch, "Calculation of Gauss quadrature
%       rules", Math. Comp. 23:221-230, 1969, 
%   [2] A. Glaser, X. Liu and V. Rokhlin, "A fast algorithm for the 
%       calculation of the roots of special functions", SIAM Journal  
%       on Scientific Computing, 29(4):1420-1438, 2007.
%   [3] L. N. Trefethen, "Is Gauss quadrature better than Clenshaw-Curtis?",
%       SIAM Review, 50(1):67–87, 2008.
%   [4] Jörg Waldvogel, "Fast construction of the Fejér and Clenshaw-Curtis 
%       quadrature rules", BIT Numerical Mathematics, 43(1):1-18, 2004.






