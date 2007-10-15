function funobj = fun(f,n)
% CHEBFUN	Constructor
% CHEBFUN(F) constructs a fun object for the function F.  If F is a string
% such as '3*x.^2+1', CHEBFUN(F) automatically determines the number of points
% for F.  F can also be a vector such as [1 0 0] which allows the construction
% of a fun with Chebyshev coefficients F.
%
% CHEBFUN(F,N) where F is a string and N a nonnegative integer creates a fun
% for F with N+1 Chebyshev points.
%
% CHEBFUN creates an empty fun.
%
% For more on funs, see Z. Battles and L. N. Trefethen,
% "An extension of Matlab to continuous functions and operators", 2003.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0

if nargin>0 
    fisnum = 0;
    if isa(f,'char'), fisnum = ~isempty(str2num(f)); end
end
if nargin==0
  funobj=struct('val',[],'n',[],'trans',int8(0),'td',int8(0));
  funobj=class(funobj,'fun');  
elseif (isempty(f) && nargin==2)
  funobj=struct('val',n,'n',size(n,1)-1,'trans',int8(0),'td',int8(0));
  funobj=class(funobj,'fun');  
elseif (isa(f,'double'))
  c=funpolyval(f(:));
  funobj=struct('val',c,'n',length(c)-1,'trans',int8(0),'td',int8(0));
  funobj=class(funobj,'fun');  
elseif (nargin == 1 && (isa(f,'function_handle') || ~fisnum))
  funobj=auto(f,fun('x',1));  
elseif ((fisnum && nargin==1) || (length(f)==4 && strcmp(f(2:4),'.^0')))
  funobj=struct('val',[],'n',[],'trans',int8(0),'td',int8(0));
  x=cheb(0);
  f=inline(f);
  funobj.val=0*x+f(x);
  funobj.n=0;
  funobj=class(funobj,'fun');  
else
  funobj=struct('val',[],'n',[],'trans',int8(0),'td',int8(0));
  x=cheb(n);
  f=inline(f);
  funobj.val=0*x+f(x);
  funobj.n=n;
  funobj=class(funobj,'fun');
end
