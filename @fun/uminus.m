function F = uminus(f)
% -	Unary minus
% -F negates the fun F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=f; F.val=-f.val;
