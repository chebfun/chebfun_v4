function F = csc(f)
% CSC	cosecant.
% CSC(F) is the cosecant of F. Effect of impulses is ignored.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = csc(F.funs{i});
end