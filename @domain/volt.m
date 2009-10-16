function V = volt(k,d)
% VOLT  Volterra integral operator.
% V = VOLT(K,D) constructs a chebop representing the Volterra integral
% operator with kernel K for functions in domain D=[a,b]:
%    
%      (F*v)(x) = int( K(x,y) v(y), y=a..x )
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
%   function K = kernel(X,Y)
%   if all(size(X)>1)       % matrix input
%     x = X(:,1);  y = Y(1,:);
%     K = exp(x)*exp(-y);   % vector outer product
%   else
%     K = exp(X-Y);
%   end
%
%  See also fred, chebop.

% Copyright 2009 by Toby Driscoll.
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.
% $Id$

C = cumsum(d);
V = chebop(@matrix,@op,d,-1);

% Functional form. At each x, do an adaptive quadrature.
  function v = op(u)
    % Result can be resolved relative to norm(u).
    scale = norm(u);
    h = @(x) chebfun(@(y) u(y).*k(x,y),[d.ends(1) x],'exps',{0 0});  % integrand at any x
    v = chebfun( vec(@(x) scale+sum(h(x))), d ,'exps',{0 0});
    v = v-scale;
  end

% Matrix form. Each row of the result, when taken as an inner product with
% function values, does the proper quadrature. Note that while C(n) would
% be triangular for low-order quadrature, for spectral methods it is not.
  function A = matrix(n)
    x = chebpts(n,d);
    [X,Y] = ndgrid(x);
    A = k(X,Y).*C(n);
  end
    

end
