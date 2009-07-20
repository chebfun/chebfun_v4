function h = hscale(f)
% HSCALE Chebfun horizantal scale
% HSCALE(F) returns the horizonatal scale to the chebfun F.

h = norm(f.ends,inf);
if h == inf
    if f.ends(1) == -inf && f.ends(end) == inf
        h = max(f.funs(1).scl.h, f.funs(end).scl.h);
    elseif f.ends(1) == -inf
        h  = max(f.funs(1).scl.h, abs(f.ends(end)));
    else
        h = max(f.funs(end).scl.h, abs(f.ends(1)));
    end
end
        