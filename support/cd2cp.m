function p = cd2cp(y);
%CD2CP  Chebyshev discretization to Chebyshev polynomials (by FFT).
%   P = CD2CP(Y) converts a vector of values at the Chebyshev extreme
%   points to the coefficients (ascending order) of the interpolating
%   Chebyshev expansion.  If Y is a matrix, the conversion is done
%   columnwise.

p = zeros(size(y));
if any(size(y)==1), y = y(:); end
N = size(y,1)-1;

yhat = fft([y(N+1:-1:1,:);y(2:N,:)])/(2*N);

p(2:N,:) = 2*yhat(2:N,:);
p([1,N+1],:) = yhat([1,N+1],:);

if isreal(y),  p = real(p);  end
