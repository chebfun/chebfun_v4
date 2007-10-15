function F = abs(f)
% ABS	Absolute value
% ABS(F) is the absolute value of F.  If F passes through 0 ABS(F) will fail.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=auto(@abs,f);