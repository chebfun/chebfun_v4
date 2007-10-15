function V = funpolyval(v)
% This function maps Chebyshev coefficients to values at Chebyshev points.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if size(v,1)==1, V=v; return; end
lv=size(v,1);
vi=2:lv-1;
if (lv>1)
    v(vi,:)=v(vi,:)/2;
end
V=[(v(end:-1:1,:));v(vi,:)];
lV=size(V,1);
if (isreal(V))
    V=real(ifft(V))*lV;
else
    V=ifft(V)*lV;
end
V=V(1:lv,:);
