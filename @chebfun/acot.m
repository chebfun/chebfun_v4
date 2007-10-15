function F = acot(f)
% ACOT	Inverse cotangent.
% ACOT(F) is the inverse cotangent of F. Effect of impulses is ignored.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = acot(F.funs{i});
end