function semilogy(f,varargin)
% SEMILOGY	Semi-log scale semilogy
% SEMILOGY(...) is the same as plot(...), except a log base 10 scale is used
% for the Y-axis.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
n=size(f,2);
h=ishold;
c='ybgrcm';
mm='markersize';
cf='fun';
if (nargin>1 & isa(varargin{1},cf))
  m=2*max([f.n varargin{1}.n 1000]);
  m2=max(f.n,varargin{1}.n);
  fv=prolong(f,m2);
  gv=prolong(varargin{1},m2);
  f=prolong(f,m);
  varargin{1}=prolong(varargin{1},m);
  t=cheb(m);
else
  m=max(2000,2*f.n);
  fv=f;
  f=prolong(f,m);
  t=cheb(m);
end
if (nargin>1 & ~isa(varargin{1},cf))
  d=[findstr('.',varargin{1}) findstr('-',varargin{1})];
  d2=findstr('.',varargin{1});
elseif (nargin>2 & ~isa(varargin{2},cf))
  d=[findstr('.',varargin{2}) findstr('-',varargin{2})];
  d2=findstr('.',varargin{2});
end
if (nargin==2 & isa(varargin{1},cf))
  for i=1:n
    semilogy(f.val(:,i),varargin{1}.val(:,i),c(mod(i,6)+1))
    hold on
  end
elseif (nargin>1 & isa(varargin{1},cf) & length(d)==2)
  for i=1:n
    s=varargin{2};
    s(d)=[' ' ' '];
    if (strcmp(s,'  ')) s=c(mod(i,6)+1); end
    semilogy(fv.val(:,i),gv.val(:,i),[s '.'],mm,28,varargin{3:end})
    hold on
    semilogy(f.val(:,i),varargin{1}.val(:,i),s,varargin{3:end})
  end
elseif (nargin>1 & length(d)==2)
  for i=1:n
    s=varargin{1};
    s(d)=[' ' ' '];
    if (strcmp(s,'  ')) s=c(mod(i,6)+1); end
    semilogy(cheb(fv.n),fv.val(:,i),[s '.'],mm,28,varargin{2:end})
    hold on
    semilogy(t,f.val(:,i),s,varargin{2:end})
  end
elseif (nargin>1 & isa(varargin{1},cf) & length(d2)==1)
  for i=1:n
    s=varargin{2};
    s(d2)=[' '];
    if (strcmp(s,' ')) s=c(mod(i,6)+1); end
    semilogy(fv.val(:,i),gv.val(:,i),[s '.'],mm,28,varargin{3:end})
  end
elseif (nargin>1 & length(d2)==1)
  for i=1:n
    s=varargin{1};
    s(d2)=[' '];
    if (strcmp(s,' ')) s=c(mod(i,6)+1); end
    semilogy(cheb(fv.n),fv.val(:,i),[s '.'],mm,28,varargin{2:end})
  end
elseif (~isreal(f.val))
  semilogy(real(f),imag(f),varargin{2:end});
else
  for i=1:n
    if (nargin>1)
      semilogy(t,f.val(:,i),varargin{:})
    else
      semilogy(t,f.val(:,i),c(mod(i,6)+1))
    end
    hold on
  end
end
if h, hold on; else hold off; end