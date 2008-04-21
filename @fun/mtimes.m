function gout = mtimes(g1,g2)
% *	Scalar multiplication
% k*G or G*k multiplies a fun G by a scalar k. 

if (isempty(g1) || isempty(g2)), gout=fun; return; end
if (isa(g1,'double'))
  gout = g2;
  gout.vals  = g1*gout.vals;
  gout.scl.v = abs(g1)*gout.scl.v;
elseif (isa(g2,'double'))
  gout = g1;
  gout.vals  = g2*gout.vals;
  gout.scl.v = abs(g2)*gout.scl.v;
elseif(isa(g1,'fun') && isa(g2,'fun'))
  error('Use .* to multiply funs.');
end