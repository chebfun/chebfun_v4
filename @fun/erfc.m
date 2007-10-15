function F = erfc(f)
% ERFC	Complementary error function
% ERFC(F) is the complementary error function for the fun F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=auto(@erfc,f);
