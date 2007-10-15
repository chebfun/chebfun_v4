function F = log10(f)
% LOG10	Base 10 logarithm
% LOG10(F) is the base 10 logarithm of the chebfun F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = log10(F.funs{i});
end