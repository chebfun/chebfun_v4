function V = volt(k,d,onevar)
% VOLT  Volterra integral operator.
% V = VOLT(K,D) constructs a chebop representing the Volterra integral
% operator with kernel K for functions in domain D=[a,b]:
%    
%      (V*v)(x) = int( K(x,y) v(y), y=a..x )
%  
% The kernel function K(x,y) should be smooth for best results.
%
% K must be defined as a function of two inputs X and Y. These may be
% scalar and vector, or they may be matrices defined by NDGRID to represent
% a tensor product of points in DxD. 
%
% VOLT(K,D,'onevar') will avoid calling K with tensor product matrices X 
% and Y. Instead, the kernel function K should interpret a call K(x) as 
% a vector x defining the tensor product grid. This format allows a 
% separable or sparse representation for increased efficiency in
% some cases.
%
% Example:
%
% To solve u(x) + x*int(exp(x-y)*u(y),y=0..x) = f(x):
% [d,x] = domain(0,2);
% V = volt(@(x,y) exp(x-y),d);  
% u = (1+diag(x)*V) \ sin(exp(3*x)); 
%
%  See also fred, chebop.
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2009 by Toby Driscoll.
%  Last commit: $Author$: $Rev$:
%  $Date$:

C = cumsum(d);
V = linop(@matrix,@op,d,-1);

% Functional form. At each x, do an adaptive quadrature.
  function v = op(u)
    % Result can be resolved relative to norm(u).
    scale = norm(u);
    h = @(x) chebfun(@(y) u(y).*k(x,y),[d.ends(1) x],'exps',{0 0});  % integrand at any x
    v = chebfun(@(x) scale+sum(h(x)), d ,'exps',{0 0},'vectorize');
    v = v-scale;
  end

% Matrix form. Each row of the result, when taken as an inner product with
% function values, does the proper quadrature. Note that while C(n) would
% be triangular for low-order quadrature, for spectral methods it is not.
if nargin==2, onevar=false; end
  function A = matrix(n)
    x = chebpts(n,d);
    if onevar  
      A = k(x);
    else
      [X,Y] = ndgrid(x);
      A = k(X,Y);
    end
    A = A.*C(n);
  end
    

end
