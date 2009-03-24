function [x,w] = legpts(n)
% X = LEGPTS(N)  N Chebyshev points in (-1,1)
%
% [X,W] = LEGPTS(N)  also includes vector of weights for Gauss quadrature

% Nick Trefethen, March 2009.
% Copyright 2002-2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if n<=0
    error('Input should be a positive number');
else
   m = n-1;
   beta = .5./sqrt(1-(2*(1:m)).^(-2));   % 3-term recurrence coeffs
   T = diag(beta,1) + diag(beta,-1);     % Jacobi matrix
   [V,D] = eig(T);                       % eigenvalue decomposition
   x = diag(D); [x,i] = sort(x);         % Legendre points
   w = 2*V(1,i).^2;                      % weights
end
