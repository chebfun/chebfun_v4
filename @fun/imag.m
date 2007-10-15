function out = imag(f)
% IMAG	Complex imaginary part
% IMAG(F) is the imaginary part of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
out=f;
out.val=imag(out.val);
if (out.val==0) out.val=0; out.n=0; end
