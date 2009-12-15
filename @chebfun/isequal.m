function out = isequal(F1,F2)
% ISEQUAL True if chebfuns are equal.
%   ISEQUAL(F1,F2) returns logical 1 (TRUE) if quasimatrices F1 and F2 are 
%   the same size and contain identical chebfuns as rows or columns, and 
%   logical 0 (FALSE)  otherwise.
%
%   See also chebfun/eq.
%
%   See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

out = true;

if size(F1) ~= size(F2)
    out = false;
    return
end

for k = 1:min(size(F1))
    if F1(k).nfuns~=F2(k).nfuns || any(F1(k).ends ~= F2(k).ends)
        out = false;
        return
    end
    if F1(k).imps ~= F2(k).imps
        out = false;
        return
    end
    for j = 1:F1(k).nfuns
        if ~isequal(F1(k).funs(j),F2(k).funs(j))
            out = false;
            return
        end
    end
end
