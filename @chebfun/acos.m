function F = acos(f)
% ACOS	Inverse cosine.
% ACOS(F) is the arccosine of the fun F. Effect of impulses is ignored.
 
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = acos(F.funs{i});
end
