function out = conj(f)
% CONJ	Complex conjugate
% CONJ(F) is the complex conjugate of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
out=f;
out.val=conj(out.val);
