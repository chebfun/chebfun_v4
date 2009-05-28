function F = fred(k,d)
% FRED  Fredholm integral operator.
% F = FRED(K,D) constructs a chebop representing the Fredholm integral
% operator with kernel K for functions in domain D=[a,b]:
%    
%      (F*v)(x) = int( K(x,y)*v(y), y=a..b )
%  
% The kernel function K(x,y) should be smooth for best results.
%
% K must be defined as a function of two inputs X and Y. These may be
% scalar and vector, or they may be matrices defined by NDGRID to represent
% a tensor product of points in DxD, so K must be vectorized accordingly.
% In the matrix case, some kernels can be evaluated much more efficiently
% using X(:,1) and Y(1,:) instead of the full matrices. For example, the
% separable kernel K(x,y) = exp(x-y) might be coded as
%
%   function K = kernel(X,Y0
%   if all(size(X)>1)       % matrix input
%     x = X(:,1);  y = Y(1,:);
%     K = exp(x)*exp(-y);   % vector outer product
%   else
%     K = exp(X-Y);
%   end
%
%  See also volt, chebop.

% Copyright 2009 by Toby Driscoll.
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.
% $Id$

F = chebop(@matrix,@op,d);

% Functional form. At each x, do an adaptive quadrature.
  function v = op(u)
    v = chebfun( vec(@(x) sum( u.*chebfun(@(y) k(x,y),d)) ), d );
  end

C = cumsum(d);
s = C(end,:);  % Clenshaw-Curtis weights for any n

% Matrix form. At given n, multiply function values by CC quadrature
% weights, then apply kernel as inner products. 
  function A = matrix(n)
    %x = -cos(pi*(0:n-1)'/(n-1));
    %x = d(1) + (x+1)/2*length(d);
    x = chebpts(d,n);
    [X,Y] = ndgrid(x);
    A = k(X,Y) * diag(s(n));
  end
    
end
