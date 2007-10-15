function varargout = svd(A,econ)
% SVD	Singular value decomposition
% [U,S,V]=SVD(A,0) produces a diagonal matrix S with nonnegative diagonal
% elements in decreasing order, a matrix U whose columns are orthogonal
% funs and a unitary matrix V such that A=U*S*V'.
%
% S=SVD(A) produces a vector containing the singular values.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if ((nargin==2 & econ~=0) | (nargin==1 & nargout>1))
  error('Use svd(A,0) for economy size decomposition.');
else
  [q,r]=qr(A,0);
  [U,S,V]=svd(r,0);
  U=q*U;
%  [V,l]=eig(A'*A);
%  [y,i]=sort(diag(l));
%  V=fliplr(V(:,i));
%  S=sqrt(diag(flipud(abs(y))));
%  u = A.val*V/(S+eps*(S==0));
%  U=A;
%  U.val=u;
end
if (nargout==3)
  varargout{1}=U; varargout{2}=S; varargout{3}=V;
elseif (nargout==1 | nargout==0)
  varargout{1}=diag(S);
end
