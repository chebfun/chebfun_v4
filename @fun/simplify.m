function out = simplify(f)
% This function removes all leading Chebyshev coefficients less than 1e-13

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
s=1e-13;
if (f.n==0) out=f; return; end
const=max(abs(f.val));
const=const+1*(const==0);
f.val=f.val/const;
c=funpoly(f);
f.val=f.val*const;
i=0;
n=length(f.val);
while (i<n & abs(c(i+1))<s) i=i+1; end
if (i~=n)
    out=prolong(f,n-i-1);
elseif (i==n & f.val(1)==f.val)
    out=prolong(f,0);
else
    out=f;
end