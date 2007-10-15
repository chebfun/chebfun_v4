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
    r = introots(f.funs{i});
    if ~isempty(r)
        F = [F;scale(r,a,b)];
    end
    % Note: ROOTS cannot identify yet a root if located at a breakpoint.
end 