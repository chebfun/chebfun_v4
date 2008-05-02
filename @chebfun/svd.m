function varargout = svd(A,econ)
% SVD	Singular value decomposition
% [U,S,V]=SVD(A,0) produces a diagonal matrix S with nonnegative diagonal
% elements in decreasing order, a matrix U whose columns are orthogonal
% chebfuns and a unitary matrix V such that A=U*S*V'.
%
% S=SVD(A) produces a vector containing the singular values.

if ((nargin==2 & econ~=0) | (nargin==1 & nargout>1))
  error('Use svd(A,0) for economy size decomposition.');
else
  [q,r]=qr(A,0);
  [U,S,V]=svd(r,0);
  U=q*U;
end
if (nargout==3)
  varargout{1}=U; varargout{2}=S; varargout{3}=V;
elseif (nargout==1 | nargout==0)
  varargout{1}=diag(S);
end