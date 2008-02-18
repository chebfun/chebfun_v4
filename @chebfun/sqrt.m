function F = sqrt(f)
% SQRT  Square root.
% SQRT(F) returns the square root chebfun of a positive or negative chebfun F. 

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0

% NOTE: if the function values of f are close to zero, SQRT will break.

% NOTE: how to treat sqrt(f) if f crosses a branch cut on negative real
% axis?

nfuns = length(f.funs);
ends = f.ends;
count = 1;
newints = ends(1);
hs = hscale(f);
for i = 1:nfuns
    fcheb = f.funs{i};
    r = scale(introots(fcheb),ends(i),ends(i+1));
    if isempty(r)
        r = [ends(i);ends(i+1)];
    else
        if abs(r(1)  - ends(i)  ) > 1e-14*hs, r = [ends(i);r  ]; end
        if abs(r(end)- ends(i+1)) > 1e-14*hs, r = [r;ends(i+1)]; end
    end
    nr = length(r);
    for i = 1:nr-1
        a = r(i); b = r(i+1);
        ff{count} = sqrt(fcheb);
        newints = [newints b];
        count = count+1;
    end
end
F = chebfun(ff,newints);
