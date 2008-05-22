function A = diag(f)
% DIAG   Pointwise multiplication operator.
% A = DIAG(F) produces a chebop that stands for pointwise multiplication by
% the chebfun F. The result of A*G is identical to F.*G.
%
% See also chebop, chebop/mtimes.

% Copyright 2008 by Toby Driscoll. See www.comlab.ox.ac.uk/chebfun.

mat = @(n) spdiags( feval( f, scaledpts(n,domain(f)) ) ,0,n,n);
oper = @(u) times(f,u);
A = chebop( mat, oper, domain(f)  );

  function x = scaledpts(n,dom)
    x = scale( -cos(pi*(0:n-1)'/(n-1)), dom(1), dom(2) );
  end

end