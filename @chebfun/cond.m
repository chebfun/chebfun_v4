function out = cond(f)
% COND	 Condition number.
% COND(F) is the 2-norm condition number of F.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

s = svd(f,0);
if any(s==0)
  out = inf;
else
  out=s(1)/s(end);
end
