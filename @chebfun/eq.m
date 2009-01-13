function out = eq(F1,F2)
% ==   Equal.
%  F1 == F2 compares chebfuns F1 and F2 and returns logical true if F1 and
%  F2 are equal and false otherwise.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

tol = 10*chebfunpref('eps');

if numel(F1) ~= numel(F2) || F1(1).trans ~= F2(1).trans
    out = false;
else
    out = true;
    for k =1: numel(F1)
        out = out && norm(F1(k)-F2(k),inf) < tol*min(F1(k).scl,F2(k).scl);
    end
end