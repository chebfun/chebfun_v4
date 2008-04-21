function gout = restrict(g,subint)
% RESTRICT Restrict a fun to a subinterval.

if (subint(1)<-1) || (subint(2)>1) || (subint(1)>subint(2))
  error('fun:restrict:badinterval','Not given an interval in [-1,1].')
end
x = chebpts(g.n);
x = 0.5*( diff(subint)*x + sum(subint) );  % translate to subinterval
gout = fun(bary(x,g.vals));
gout.scl.h = gout.scl.h*...
    (2/(subint(2)-subint(1)));             % update horizontal scale.
gout = simplify(gout);                     % may get significantly smaller