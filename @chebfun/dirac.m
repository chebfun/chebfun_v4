function d = dirac(f)
% DIRAC delta function
%  D = DIRAC(F) returns a chebfun D which is zero on the domain of the
%  chebfun F except at the roots of F, where it is infinite.
%  
%  See also chebfun/heaviside

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

[a b] = domain(f);
r = roots(f);
ends = union(r,[a,b]);

d = chebfun(0,ends);
d.imps(2,2:end-1) = 1;

tol = chebfunpref('eps');
if abs( feval(f,a) ) < 100*tol*f.scl
    d.imps(2,1) = 1;
end
if abs( feval(f,b) ) < 100*tol*f.scl
    d.imps(2,end) = 1;
end




