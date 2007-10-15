function varargout = size(f,k)
% SIZE	Size of fun
% SIZE(F) returns the size of the fun F.  Negative dimensions are used to
% indicate dimensions of funs.
%
% SIZE(F,DIM), DIM=1 or DIM=2, returns the length of the fun in the
% dimension specified by DIM.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (isempty(f))
  m=0; n=0;
elseif (f.td)
  [m,n]=size(f.val);
  m=-m; n=-n;
else
  [m,n]=size(f.val);
  if (f.trans)
    n=-f.n;
  else
    m=-f.n;
  end
end
if(nargin==2 & k==1)
  varargout{1}=m;
elseif(nargin==2 & k==2)
  varargout{1}=n;
elseif(nargout<=1)
  varargout{1}=[m n];
else
  varargout{1}=m;
  varargout{2}=n;
end
