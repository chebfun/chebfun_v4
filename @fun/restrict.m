function g = restrict(f,subint)

% RESTRICT Restrict a fun to a subinterval.
if (subint(1)<-1) || (subint(2)>1) || (subint(1)>subint(2))
  error('fun:restrict:badinterval','Not given an interval in [-1,1].')
end
x = cheb(f.n);
x = 0.5*( diff(subint)*x + sum(subint) );   % translate to subinterval
g = fun;
g.n = f.n;
g.val = bary(x,f.val);
g = simplify(g);                            % may get significantly smaller
