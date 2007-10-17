function F = roots(f)
% ROOTS	Roots of a chebfun
% ROOTS(F) returns the roots of F in the interval where it is defined.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
nfuns = length(f.funs);
ends = f.ends;
F = [];
for i = 1:nfuns
    a = ends(i); b = ends(i+1);
    lfun = f.funs{i};
    r = introots(lfun);
    if ~isempty(r)
        F = [F;scale(r,a,b)];
    end
    if abs(lfun(1)) <= 1e-15
        F = [F;b];
    elseif i < nfuns
        rfun = f.funs{i+1};
        if lfun(1)*rfun(-1) < 0
            F = [F;b];
        end
    end    
end 