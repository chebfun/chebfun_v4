function F = log2(f)
% LOG2	Base 2 logarithm
% LOG2(F) is the base 2 logarithm of the chefun F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = log2(F.funs{i});
end