function F = fred(k,d,onevar)
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
% a tensor product of points in DxD. 
%
% FRED(K,D,'onevar') will avoid calling K with tensor product matrices X 
% and Y. Instead, the kernel function K should interpret a call K(x) as 
% a vector x defining the tensor product grid. This format allows a 
% separable or sparse representation for increased efficiency in
% some cases.
%
% Example:
%
% To solve u(x) - x*int(exp(x-y)*u(y),y=0..2) = f(x), in a way that 
% exploits exp(x-y)=exp(x)*exp(-y), first write:
%
%   function K = kernel(X,Y)
%   if nargin==1   % tensor product call
%     K = exp(x)*exp(-x');   % vector outer product
%   else  % normal call
%     K = exp(X-Y);
%   end
%
% At the prompt:
%
% [d,x] = domain(0,2);
% F = fred(@kernel,d);  % slow way
% tic, u = (1-diag(x)*F) \ sin(exp(3*x)); toc
%   %(Elapsed time is 0.265166 seconds.)
% F = fred(@kernel,d,'onevar');  % fast way
% tic, u = (1-diag(x)*F) \ sin(exp(3*x)); toc
%   %(Elapsed time is 0.205714 seconds.)
%
% See also volt, chebop.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2009 by Toby Driscoll and Folkmar Bornemann.

%  Last commit: $Author$: $Rev$:
%  $Date$:

F = linop(@matrix,@op,d);

% Functional form. At each x, do an adaptive quadrature.
  function v = op(u)
    % Result can be resolved relative to norm(u). (For instance, if the
    % kernel is nearly zero by cancellation on the interval, don't try to
    % resolve it relative to its own scale.) 
    opt = {'resampling',false,'splitting',true,'exps',{0 0},'scale',norm(u)};
    int = @(x) sum(u.* (chebfun(@(y) k(x,y),d,opt{:})));
    v = chebfun( int, d,'sampletest',false,'resampling',false,'exps',{0 0},'vectorize','scale',norm(u));
  end

% Matrix form. At given n, multiply function values by CC quadrature
% weights, then apply kernel as inner products. 
if nargin==2, onevar=false; end
  function A = matrix(n)
    [x s] = chebpts(n,d);
    if onevar  % experimental
      A = k(x)*spdiags(s',0,n,n);
    else
      [X,Y] = ndgrid(x);
      A = k(X,Y) * spdiags(s',0,n,n);
    end
  end
    
end
