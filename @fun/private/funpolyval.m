function V = funpolyval(v)
% This function maps Chebyshev coefficients to values at Chebyshev points.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
lv = size(v,1);
if lv == 1, V=v; return; end
ii = 2:lv-1;
v(ii,:) = v(ii,:)/2;
V = [(v(end:-1:1,:)); v(ii,:)];
if isreal(V)
    V=real(ifft(V));
elseif isreal(1i*V)
    V=1i*imag(ifft(V));
else
    V=ifft(V);
end
V = (lv-1)*[2*V(1,:); (V(ii,:)+V(2*lv-ii,:)); 2*V(lv,:)];
