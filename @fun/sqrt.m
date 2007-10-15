function F = sqrt(f)
% SQRT Square root
% SQRT(F) is the square root of F.  If F passes through 0 SQRT(F) will fail.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=auto(@sqrt,f);

