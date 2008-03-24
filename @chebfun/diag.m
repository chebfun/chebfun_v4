function A = diag(f)

A = chebop( @(n) diag( feval( f, -cos(pi*(0:n-1)'/(n-1))) ) );
