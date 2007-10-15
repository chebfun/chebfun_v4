function F = exp(f)
% EXP	Exponential
% EXP(F) is the exponential of the chebfun F; e to the F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = exp(F.funs{i});
end