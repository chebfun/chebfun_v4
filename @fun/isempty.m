function out = isempty(g)
% ISEMPTY	True for empty fun
% ISEMPTY(G) returns one if F is an empty fun and zero otherwise.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

if numel(g) > 1
    out = 0;
else
    out = isempty(g.vals);
end
