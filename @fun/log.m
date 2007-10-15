function F = log(f)
% LOG	Natural logarithm
% LOG(F) is the natural logarithm of F.  If F passes through 0 LOG(F) will fail.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=auto(@log,f);
