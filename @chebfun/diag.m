function A = diag(f)

A = chebop( @(n) spdiags( feval( f, -cos(pi*(0:n-1)'/(n-1))) ,0,n,n)  );
