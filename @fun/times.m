function gout = times(g1,g2)
% .*	Chebfun multiplication
% G1.*G2 multiplies funs G1 and G2 or a fun by a scalar if either G1 or G2 is
% a scalar.

if (isempty(g1) || isempty(g2)), gout=fun; return; end
if (isa(g1,'double') || isa(g2,'double'))
  gout = mtimes(g1,g2);
  return;
end  

temp=prolong(g1,g1.n+g2.n-1); 
if g1==g2
   vals=temp.vals.^2;          
elseif conj(g1)==g2
   vals=conj(temp.vals).*temp.vals;
else
   temp2=prolong(g2,g1.n+g2.n-1); 
   vals=temp.vals.*temp2.vals;
end
%scl.h = max(g1.scl.h,g2.scl.h);
%scl.v = max(g1.scl.v,g2.scl.v);
gout = fun(vals); 
gout = simplify(gout);