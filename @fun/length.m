function m = length(f)
% LENGTH	Length of a fun
% LENGTH(F) is the number of Chebyshev points N.  Negative values are used to
% indicate dimensions of funs.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (isempty(f)) m=0; return; end
[m,n]=size(f);
if (f.trans), m=n; end
