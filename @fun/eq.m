function F = eq(f,g)
% ==	Equal
% F == G compares funs F and G and returns one if F and G are
% equal and zero otherwise.  A scalar can be compared with a fun.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (isa(f,'double'))
  f=f*fun('1');
elseif (isa(g,'double'))
  g=g*fun('1');
end
f=simplify(f);
g=simplify(g);
if (length(f.val)==length(g.val))
  F=min(f.val==g.val);
else
  F=(1==0);
end
