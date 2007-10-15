function out = real(f)
% REAL	Complex real part
% REAL(F) is the real part of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
out=f;
out.val=real(out.val);
if (out.val==0) out.val=0; out.n=0; end
