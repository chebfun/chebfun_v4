function F = acsc(f)
% ACSC	Inverse cosecant.
% ACSC(F) is the inverse cosecant of F. Effect of impulses is ignored.
 
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = acsc(F.funs{i});
end
