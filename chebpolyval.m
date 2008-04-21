function v = chebpolyval(c)
% This function maps Chebyshev coefficients to values at Chebyshev points.

c = c(:);       % input should be a column vector
lc = length(c);
if lc == 1, v = c; return; end
ii = 2:lc-1;
c(ii) = c(ii)/2;
v = [(c(end:-1:1)); c(ii)];
v=ifft(v);
if isreal(c)
    v=real(v);
elseif isreal(1i*c)
    v=1i*imag(v);
end
v = (lc-1)*[2*v(1); (v(ii)+v(2*lc-ii)); 2*v(lc)];
v=flipud(v);