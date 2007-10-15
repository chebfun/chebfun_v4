function F = erfinv(f)
% ERFINV	Inverse error function
% ERFINV(F) is the inverse error function for the chebfun F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = erfinv(F.funs{i});
end