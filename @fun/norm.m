function F = norm(f,n)
% NORM	Chebfun norm
% For matrices whose columns are funs...
%	NORM(A) is the largest singular value of A.
%	NORM(A,2) is the same as NORM(A).
%	NORM(A,1) is the maximum over the 1-norms of the columns of A.
%	NORM(A,'fro') is the Frobenius norm, sqrt(sum(svd(A).^2)).
%
% For funs...
%	NORM(F) = NORM(F,2).
%	NORM(F,2) = sqrt(integral from -1 to 1 F^2)).
%	NORM(F,1) = integral from -1 to 1 abs(F).
%	NORM(F,inf) = max(abs(F)).
%	NORM(F,-inf) = min(abs(F)).

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (nargin==1), n=2; elseif strcmp(n,'inf'), n=inf; elseif strcmp(n,'-inf'), n=-inf; end
if (f.trans) f=f.'; end
q=size(f.val,2);
if n==2 & q==1
  if (isreal(f.val))
    f.val=funpolyval([zeros(f.n,1);funpoly(f)']);
    f.n=2*f.n;
    f.val=f.val.^2;
    F=sqrt(abs(sum(f)));
  else
    F=sqrt(real(f'*f));
  end
elseif n==2 & q>1
  s=svd(f,0);
  F=s(1);
elseif n==1 & q==1
  r=introots(f);
  p=cumsum(f);
  r=bary([-1 r' 1],p.val);
  F=sum(abs(diff(r)));
elseif n==1 & q>1
  S=struct('type','()','subs',{{':'}});
  for (i=1:q), S.subs{2}=i; t(i)=norm(subsref(f,S),1); end
  F=max(t);
elseif strcmp(n,'fro')
  s=svd(f,0);
  F=sqrt(sum(s(s>0).^2));
elseif n==inf & q==1
  r=introots(diff(f));
  F=max(abs(bary([-1 r' 1],f.val)));
elseif n==-inf & q==1
  r=introots(diff(f));
  F=min(abs(bary([-1 r' 1],f.val)));
end
