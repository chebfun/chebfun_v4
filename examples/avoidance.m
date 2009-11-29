function E = avoidance(A,B)

%  Input: Square symmetric matrices A, B of the same dimension n.
%         If no inputs are specified, A, B are random with n=10.
% Output: Quasimatrix E with n columns representing the sorted eigenvalues
%         of (1-t)A + tB, 0<t<1.  Type plot(avoidance) to see picture.
%         If no output arguments are specified this happens automatically.

if nargin==0
   A = randn(10); A = A+A'; B = randn(10); B = B+B';
end
n = length(A); [d,t] = domain(0,1); E = chebfun;
for k = 1:n
   E(:,k) = chebfun(@(t) eigk((1-t)*A+t*B,k),d,'splitting','on','vectorize');
end

if nargout==0, plot(E), shg, end

function ek = eigk(A,k)  % return kth eigenvalue of A
e = sort(eig(A)); ek = e(k);
