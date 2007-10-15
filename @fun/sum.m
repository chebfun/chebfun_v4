function F = sum(f,dim)
% SUM	Definite integral from -1 to 1
% SUM(F) is the integral from -1 to 1 of F.  If F is a matrix whose columns are
% funs SUM(F) returns a vector containing the definite integrals of the
% columns of F.
%
% SUM(F,2) is the sum of the column funs of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (nargin==2 & dim==2)
  F=f;
  F.val=sum(F.val,2);
  return;
elseif (nargin==2 & dim~=1 & dim~=2)
  F=f;
  return;
end
if (f.n==0) F=f.val*2; return; end
if (f.trans) f.val=f.val.'; end
c=funpoly(f);
c=c(:,end:-1:1);
c(:,2:2:end)=0;
F=(c*[2 0 2./(1-((2:size(c,2)-1)).^2)]').';
