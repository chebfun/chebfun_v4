function out = ctranspose(f)
% '	Complex conjugate transpose
% F' is the complex conjugate transpose of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
out=f;
out.val=out.val';
if (~f.td), out.trans=not(out.trans); end
