function out = cond(f)
% COND	 Condition number.
% COND(F) is the 2-norm condition number of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

s = svd(f,0);
if any(s==0)
  out = inf;
else
  out=s(1)/s(end);
end
