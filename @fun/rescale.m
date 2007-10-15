function F = rescale(f,n)
% RESCALE	Rescale fun
% RESCALE(F,N) returns the order N representation of the fun F.
% RESCALE(F) returns the minimal representation of the fun F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (nargin==2)
  F=prolong(f,n);
else
  F=simplify(f);
end
