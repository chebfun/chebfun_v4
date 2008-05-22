function out = isempty(g)
% ISEMPTY	True for empty fun
% ISEMPTY(G) returns one if F is an empty fun and zero otherwise.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if numel(g) > 1
    out = 0;
else
    out = isempty(g.vals);
end
