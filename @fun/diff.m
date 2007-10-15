function F = diff(f,n)
% DIFF	Differentiation
% DIFF(F) is the derivative of the fun F.  If F is a matrix whose columns
% are funs DIFF(F) returns a matrix whose columns are the derivatives of
% the columns of F.
%
% DIFF(F,N) is the N-th derivative of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=fun;
if (nargin==1) n=1; end
if (f.trans) f.val=f.val.'; end
while (n>=1)
  if f.n==0, F=f; F.val(1,:)=0; return, end
  v=funpoly(f);
  v=v(:,end:-1:1);
  V=zeros(size(v,1),f.n);
  V(:,1)=2*(f.n)*v(:,end);
  i=f.n-1:-1:1;
  ii=i(ones(size(v,1),1),:);
  fj=2*ii.*v(:,i+1);
  Vi=V(:,1*ones(1,size(fj(:,2:2:end),2)),:);
  V(:,3:2:end)=Vi+cumsum(fj(:,2:2:end),2);
  V(:,2:2:end)=cumsum(fj(:,1:2:end),2);
  V(:,end)=V(:,end)*.5;
  F.val=funpolyval(V.');
  F.n=f.n-1;
  f=F;
  F.val=[];
  n=n-1;
end
if (f.trans) F.val=F.val.'; end
F=f;