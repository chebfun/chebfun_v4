function out = isequal(g1,g2)
% ISEQUAL True if funs are equal.
%    ISEQUAL(A,B) returns logical 1 (TRUE) if fund G1 and G2 are the same
%    length and contain the same values, and logical 0 (FALSE) otherwise.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if g1.n==g2.n && all(g1.vals==g2.vals)
    out = true;
else
    out = false;
end