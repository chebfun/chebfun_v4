function F = tan(f)
% TAN Tangent
% TAN(F) is the tangent of F. Effect of impulses is ignored.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = tan(F.funs{i});
end
