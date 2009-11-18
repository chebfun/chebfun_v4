function A = diag(f)
% DIAG   Pointwise multiplication operator.
% A = DIAG(F) produces a chebop that stands for pointwise multiplication by
% the chebfun F. The result of A*G is identical to F.*G.
%
% See also chebop, chebop/mtimes.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2008 by Toby Driscoll. 

mat = @(n) spdiags( feval( f, chebpts(n,domain(f)) ) ,0,n,n);
oper = @(u) times(f,u);
A = chebop( mat, oper, domain(f)  );

end