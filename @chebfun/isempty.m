function isemp = isempty(F)
% ISEMPTY   True for empty chebfun.
% ISEMPTY(F) returns logical true if F is an empty chebfun and false 
% otherwise.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

isemp = true;

for k = 1:numel(F)
    if ~isempty(F(k).ends)
        isemp = false;       
        return
    end
end