function A = diag(f,d)
% DIAG   Pointwise multiplication operator. (THIS NEEDS CHANGING)
% A = DIAG(F) produces a chebop that stands for pointwise multiplication by
% the chebfun F. The result of A*G is identical to F.*G.
%
% See also chebop, chebop/mtimes.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Last commit: $Author$: $Rev$:
%  $Date$:

mat = @(n) spdiags( feval( @(x)f(trim(x)), chebpts(n,d) ) ,0,n,n);
oper = @(u) chebfun(@(x) feval(f,x).*feval(u,x),d);
A = linop( mat, oper, d  );

end

function y = trim(x)
% This function forces x to be in [-10^16,10^16]
y = x;
y(y==inf) = 1e18;
y(y==-inf) = -1e18;
end