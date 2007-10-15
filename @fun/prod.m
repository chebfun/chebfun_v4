function F = prod(f)
% PROD	Integral of product
% PROD(F) is the integral of product of F.  If F is a matrix whose columns are
% funs the result is a matrix whose columns are the integral of products of
% the columns of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=fun;
S=struct('type','()','subs',{{{':'},1}});
for i=1:size(f,2)
  S.subs{2}=i;
  F=[F exp(sum(log(subsref(f,S))))];
end
