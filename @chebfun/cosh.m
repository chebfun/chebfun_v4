function F = cosh(f)
% COSH	Hyperbolic cosine.
% COSH(F) is the hyperbolic cosine of F. Effect of impulses is ignored.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = cosh(F.funs{i});
end