function isemp = isempty(F)
% ISEMPTY   True for empty chebfun.
% ISEMPTY(F) returns logical true if F is an empty chebfun and false 
% otherwise.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.


isemp = true;

for k = 1:numel(F)
    isemp = true && isempty(F(k).funs);
end