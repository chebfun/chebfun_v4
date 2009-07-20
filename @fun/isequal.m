function out = isequal(g1,g2)
% ISEQUAL True if funs are equal.
%    ISEQUAL(A,B) returns logical 1 (TRUE) if fund G1 and G2 are the same
%    length and contain the same values, and logical 0 (FALSE) otherwise.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

if g1.n==g2.n && all(g1.vals==g2.vals)
    out = true;
else
    out = false;
end