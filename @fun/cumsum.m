function F = cumsum(f)
% CUMSUM	Indefinite integral
% CUMSUM(F) is the indefinite integral of the fun F.  If F is a matrix whose
% columns are funs the result is a matrix whose columns are the indefinite
% integrals of the columns of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (~f.td)
  if (f.n==0 & ~f.trans)
    F=prolong(f,1);
    F.val(1,:)=2*F.val(1,:);
    F.val(2,:)=0;
    return;
  end
  F=f;
  F.val=zeros(f.n+2,size(f.val,2));
  F.n=f.n+1;
  q=size(f.val,2);
  a=funpoly(f);
  a=a(:,end:-1:1);
  la=size(a,2);
  g=zeros(q,la+1);
  qi=1:la-2;
  g(:,2:la-1)=(a(:,1:la-2)-a(:,3:la))./(2*qi(ones(q,1),:));
  if (f.n>1)
    g(:,2)=a(:,1)-a(:,3)/2;
    g(:,end-1)=a(:,end-1)/f.n/2;
    g(:,end)=a(:,end)/(2*(f.n+1));
    si=(-1).^(2:f.n+2);
    g(:,1)=sum(g(:,2:end).*si(ones(q,1),:),2);
    g=g(:,end:-1:1);
  elseif (f.n==1)
    g(:,1)=a(:,end)/4;
    g(:,2)=a(:,1);
    g(:,3)=g(:,2)-g(:,1);
  end
  g(:);
  F.val=funpolyval(g.');
  if (f.trans) F.val=F.val.'; end
end
