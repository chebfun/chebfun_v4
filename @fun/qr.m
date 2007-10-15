function [q,r] = qr(A,econ)
% QR	QR factorization
% [Q,R]=QR(A,0) produces a matrix Q with orthogonal column funs and an upper
% triangular matrix R such that A=Q*R.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (nargin==2 & econ==0)
  [m,n]=size(A.val);
  q=A;
  q.val=[];
  QS=A;
  AS=A;
  AT=A;
  for j=1:n
    AS.val=A.val(:,j);
    r(j,j)=norm(AS);
    if (r(j,j)>=eps)
      qfun=AS.val/r(j,j);
      q.val(:,j)=qfun;
    else
      T=struct('type','()','subs',{{':'}});
      temp=fun('1',m-1);
      temp.val=randn(m,1);
      for i=1:j-1
        T.subs{2}=i;
        temp=temp-subsref(q,T)'*temp*subsref(q,T);
      end
      temp=temp/norm(temp);
      q.val(:,j)=temp.val;
      r(j,j)=0;
      qfun=q.val(:,j);
    end
    ii=j+1:n;
    QS.val=qfun;
    Aii=A.val(:,ii);
    AT.val=Aii;
    if (j+1<=n), r(j,ii)=QS'*AT; end
    A.val(:,ii)=Aii-repmat(r(j,ii),m,1).*repmat(qfun,1,length(ii));
  end
else
  error('Use qr(A,0) for economy size decomposition.');
end
