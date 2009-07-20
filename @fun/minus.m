function g1 = minus(g1,g2)
% -	Minus
% G1 - G2 subtracts fun G1 from G2 or a scalar from a fun if either
% G1 or G2 is a scalar.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

%if (isempty(g1) || isempty(g2)), gout=fun; return; end

% Scalar case:
if isa(g1,'double')
  g2.vals = g1-g2.vals; g2.scl.v = max(g2.scl.v,norm(g2.vals,inf));
  g1 = g2;
  return;
elseif isa(g2,'double')
  g1.vals = g1.vals-g2; g1.scl.v = max(g1.scl.v,norm(g1.vals,inf));
  return;
end

% Deal with maps
% If two maps are different, call constructor.
if ~samemap(g1,g2)
    g1 = compfun(g1,@(f,g) f-g,g2);
    return
end

% Otherwise use standard procedure:
gn1=g1.n;
gn2=g2.n;
if (gn1 > gn2)
  g2=prolong(g2,gn1);
  vals=g1.vals-g2.vals;
elseif gn1 < gn2
  g1=prolong(g1,gn2);
  vals=g1.vals-g2.vals;
elseif (g1.vals==g2.vals)
  vals=0;
else
  vals=g1.vals-g2.vals;  
end

g1.vals = vals;
g1.scl.h = max(g1.scl.h,g2.scl.h);
g1.scl.v = max([g1.scl.v,g2.scl.v,norm(vals,inf)]);
g1.n = length(vals);
