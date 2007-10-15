function F = coth(f)
% COTH	Hyperbolic cotangent.
% COTH(F) is the hyperbolic cotangent of F. Effect of impulses is ignored.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = coth(F.funs{i});
end