function F = asec(f)
% ASEC	Inverse secant.
% ASEC(F) is the inverse secant of F. Effect of impulses is ignored.
 
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = asec(F.funs{i});
end
