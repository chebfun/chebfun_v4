function F = rdivide(f,g)
% ./	Right fun divide
% F./G is the fun division of G into F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (isempty(f) | isempty(g)), F=fun; return; end
if (isa(g,'double'))
  F = mrdivide(f,g);
elseif (isa(f,'double'))
  f=f*fun('1');
  F=auto(@rdivide,f,g);
elseif(length(f.val)==length(g.val) & f.val==g.val)
  F=f;
  F.val=1;
  F.n=0;
else
  F=auto(@rdivide,f,g);
end
