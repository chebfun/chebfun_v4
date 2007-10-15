function [out,i] = max(f)
% MAX	Global maximum on [-1,1]
% MAX(F) is the global maximum of the fun F on [-1,1].
% [Y,X] = MAX(F) returns the value X such that Y = F(X), Y the global maximum.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
r=introots(diff(f));
r=[-1;r;1];
if (isreal(f))
  [out,i]=max(real(bary(r,f.val)));
  i=r(i);
else
  [out,i]=max(bary(r,f.val));
  i=r(i);
end