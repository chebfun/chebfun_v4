function F = atan(f)
% ATAN	Inverse tangent.
% ATAN(F) is the inverse tangent of F. Effect of impulses is ignored.
 
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = atan(F.funs{i});
end
