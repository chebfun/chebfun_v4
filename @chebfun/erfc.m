function F = erfc(f)
% ERFC	Complementary error function
% ERFC(F) is the complementary error function for the chebfun F.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = erfc(F.funs{i});
end
