function y = cp2cd(p);
%CP2CD   Chebyshev polynomials to Chebyshev discretization (by FFT).
%   CP2CD(P) converts a vector of coefficients of Chebyshev 
%   polynomials to the values of the expansion at the extreme
%   points. If P is a matrix, the conversion is done columnwise.

y = zeros(size(p));
if any(size(p)==1), p = p(:); end
N = size(y,1)-1;

p(2:N,:) = p(2:N,:)/2;
phat = ifft([p(1:N,:);p(N+1:-1:2,:)])*(2*N);

y = phat(N+1:-1:1,:);
if isreal(p),  y = real(y);  end
