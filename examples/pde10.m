% pde10.m -- Compute Green's function for u''+pu'+qu=f, u(+-1)=0.
%     The output G is such that G(x) is a chebfun that can be integrated
%     against any f(y) to produce the solution u(x).
%
%     Example:
%        G = pde10( @(x) 0*x, @(x) -9*ones(size(x)) );
%        for xj = -0.8:0.2:0.8, plot(G(xj)), hold on, end
%        
%   TAD, 22 Jan 2007

function G = green(p,q)

if nargin==0
  p = chebfun(@(x) 0*x);
  q = chebfun(@(x) -ones(size(x)));
elseif isa(p,'function_handle')
  p = chebfun(p);
  q = chebfun(q);
end

% Find the two independent solutions of the homogeneous BVP.
BC = [1;0];  g1 = chebfun( @homog );
BC = [0;1];  g2 = chebfun( @homog );

  function g = homog(x)
    N = length(x)-1;
    D = cheb(N);  D2 = D^2;
    A = D2 + diag(p(x))*D + diag(q(x));
    rhs = -A(2:N,[1 N+1])*BC([2 1]);
    g = A(2:N,2:N)\rhs;
    g = [BC(2);g;BC(1)];
  end

y = fun('x');
W = g1.*diff(g2) - g2.*diff(g1);         % Wronskian
g1W = g1./W;  g2W = g2./W;
G = @greenconstructor;

  function g = greenconstructor(x)
    if abs(x) < 1
      H = chebfun( {0*y,sign(1+y)}, [-1 x 1] );   % Heaviside
      g = (-g1(x))*( (1-H).*g2W ) + (-g2(x))* ( H.*g1W );
%      g = (-g1(x))*( ((1-H).*g2)./W ) + (-g2(x))* ( (H.*g1)./W );
    else
      g = chebfun( @(y) 0*y );
    end      
  end

end  % green()
