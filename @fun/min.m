function [out,i] = min(f)
% MIN	Global minimum on [-1,1]
% MIN(F) is the global minimum of the fun F on [-1,1].
% [Y,X] = MIN(F) returns the value X such that Y = F(X), Y the global minimum.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
r=introots(diff(f));
r=[-1;r;1];
if (isreal(f.val))
  [out,i]=min(real(bary(r,f.val)));
  i=r(i);
else
  [out,i]=min(bary(r,f.val));
  i=r(i);
end