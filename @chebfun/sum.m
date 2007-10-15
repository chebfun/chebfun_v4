function F = sum(f)
% SUM	Definite integral
% SUM(F) is the integral of F in the interval where it is defined.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
nfuns = length(f.funs);
ends = f.ends;
F = 0;
for i = 1:nfuns
    fcheb = f.funs{i};
    a = ends(i); b = ends(i+1);
    F = F + (b-a)*sum(fcheb)/2;
end
if not(isempty(f.imps))
    F = F + sum(f.imps(1,:));
end