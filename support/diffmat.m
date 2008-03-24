function D = diffmat(N)

% For use with chebop: Chebyshev differentiation matrix.
%
% Idiom: D = chebop(@diffmat);

N = N-1;
if N==0, D=0; return, end
x = cos(pi*(0:N)'/N);
c = [2; ones(N-1,1); 2] .* (-1).^(0:N)';
X = repmat( x, [1,N+1] );
dX = X-X.';
D = (c*(1./c)') ./ (dX+eye(N+1));
D = D - diag(sum(D.'));
D = fliplr(flipud(D));
