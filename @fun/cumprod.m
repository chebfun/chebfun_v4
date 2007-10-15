function F = cumprod(f)
% CUMPROD	Indefinite integral of product
% CUMPROD(F) is the indefinite integral of product of F.  If F is a matrix whose
% columns are funs the result is a matrix whose columns are the indefinite
% integral of products of the columns of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
F=fun;
S=struct('type','()','subs',{{{':'},1}});
for i=1:size(f,2)
  S.subs{2}=i;
  F=[F exp(cumsum(log(subsref(f,S))))];
end
