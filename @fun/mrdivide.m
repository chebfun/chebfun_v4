function F = mrdivide(f,g)
% /	Right scalar divide
% F/C divides the fun F by a scalar C.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (isempty(f)), F=fun; return; end
if (isa(g,'double'))
  F=f;
  F.val=f.val/g;
else
  error('Use ./ to divide a fun into a fun.');
end
