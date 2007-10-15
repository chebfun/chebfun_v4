function out = mldivide(f,g)
% \	Backslash
% X = A\B, X a vector, A a matrix whose columns are funs and B a fun,
% is the solution in the least squares sense of A*X = B.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (isa(f,'double') | isa(g,'double'))
  out=rdivide(g,f);
else
  [q,r]=qr(f,0);
  out=r\(q'*g);
end
