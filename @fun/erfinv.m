function F = erfinv(f)
% ERFINV	Inverse error function
% ERFINV(F) is the inverse error function for the fun F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=auto(@erfinv,f);
