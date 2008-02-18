function F = real(f)
% REAL	Complex real part
% REAL(F) is the real part of F.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = real(F.funs{i});
end
