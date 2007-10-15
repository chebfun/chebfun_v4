function F = times(f,g)
% .*	Chebfun multiplication
% F.*G multiplies funs F and G or a fun by a scalar if either F or G is
% a scalar.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (isempty(f) | isempty(g)), F=fun; return; end
if (isa(f,'double') | isa(g,'double'))
  F = mtimes(f,g);
elseif (size(f,2)==1 & size(g,2)==1)
   F=f;
%   [temp,temp2] = prolong(f,f.n+g.n,g);
   temp=prolong(f,f.n+g.n);
   temp2=prolong(g,f.n+g.n);
   F.val=temp.val.*temp2.val;
   F.n = f.n+g.n;
   F=simplify(F);
%  F=auto(@times,f,g);
end
