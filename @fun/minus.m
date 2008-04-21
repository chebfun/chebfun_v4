function gout = minus(g1,g2)
% -	Minus
% G1 - G2 subtracts fun G1 from G2 or a scalar from a fun if either
% G1 or G2 is a scalar.

if (isempty(g1) || isempty(g2)), gout=fun; return; end

if isa(g1,'double')
  gout = set(g2,'vals',g1-g2.vals);
  return;
elseif isa(g2,'double')
  gout = set(g1,'vals',g1.vals-g2);
  return;
end
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

gout = fun(vals);
gout.scl.h = max(g1.scl.h,g2.scl.h);
gout.scl.v = max([g1.scl.v,g2.scl.v,gout.scl.v]);
