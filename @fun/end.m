function endval = end(f,k,n)
% End	Last index
% END can serve as the last index in an expression.  F(END) evaluates the
% fun F at 1.  A(end,end), A a matrix whose columns are funs, evaluates
% the last column of A at 1.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (f.trans), N=size(f,1); else N=size(f,2); end
if (k==1)
  endval=-1;
else
  endval=N;
end
