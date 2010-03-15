function [x w] = hermpts(n,type)
%HERMPTS  Hermite points and Gauss-Hermite Quadrature Weights.
%  HERMPTS(N) returns N Hermite points X in (-1,1). By default these are
%  roots of the 'physicist'-type Hermite polynomials, which are orthogonal
%  with respect to the weight exp(-x.^2).
%
%  [X,W] = HERMPTS(N) also returns a row vector of weights for Gauss-Hermite 
%  quadrature.
%
%  [X,W] = HERMPTS(N,'PROB') normalises instead by the probablist's definition
%  (with weight exp(-x.^2/2)), which gives rise to monomials.
%
%  See also chebpts, legpts, lagpts, and jacpts.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  'GW' by Nick Trefethen, March 2009 - algorithm adapted from [1].
%  'FAST' by Nick Hale, March 2010 - algorithm adapted from [2].
%
%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: hale $: $Rev: 1022 $:
%  $Date: 2010-01-25 14:06:01 +0000 (Mon, 25 Jan 2010) $:
%
%  References:
%   [1] G. H. Golub and J. A. Welsch, "Calculation of Gauss quadrature
%       rules", Math. Comp. 23:221-230, 1969, 
%   [2] A. Glaser, X. Liu and V. Rokhlin, "A fast algorithm for the 
%       calculation of the roots of special functions", SIAM Journal  
%       on Scientific Computing", 29(4):1420-1438:, 2007.

% NOTE: FAST IS NOT YET IMPLIMENTED!
%  [X,W] = HERMPTS(N,METHOD) allows the user to select which method to use.
%  METHOD = 'GW' will use the traditional Golub-Welsch eigenvalue method,
%  which is best for when N is small. METHOD = 'FAST' will use the
%  Glaser-Liu-Rokhlin fast algorithm, which is much faster for large N.
%  By default LEGPTS uses 'GW' when N < 128. 

if nargin == 1
    type = 'phys';
end

% decide to use GW or FAST
% if (n < 128 || strcmpi(method,'GW')) && ~strcmpi(method,'fast') % GW, see [1]
   beta = sqrt(.5*(1:n-1));              % 3-term recurrence coeffs
   T = diag(beta,1) + diag(beta,-1);     % Jacobi matrix
   [V,D] = eig(T);                       % eigenvalue decomposition
   [x,indx] = sort(diag(D));             % Hermite points
   w = sqrt(pi)*V(1,indx).^2;            % weights
       
   % enforce symmetry
   ii = 1:floor(n/2);  x = x(ii);  w = w(ii);
   if mod(n,2)
        x = [x ; 0 ; -flipud(x)];  w = [w  sqrt(pi)-sum(2*w) fliplr(w)];
   else
        x = [x ; -flipud(x)];      w = [w fliplr(w)];
   end
% else                                                            % Fast, see [2]
    % fast algorithm to be implemented
% end
w = (sqrt(pi)/sum(w))*w;                 % normalise so that sum(w) = sqrt(pi)

if strcmpi(type,'prob')
    x = x*sqrt(2);
    w = w*sqrt(2);
end
    

