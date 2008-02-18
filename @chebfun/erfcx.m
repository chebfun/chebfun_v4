function F = erfcx(f)
% ERFCX	Scaled complementary error function
% ERFCX(F) is the scaled complementary error function for the chebfun F.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = erfcx(F.funs{i});
end
