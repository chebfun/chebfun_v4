function F = erf(f)
% ERF	Error function
% ERF(F) is the error function for the chebfun F.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = erf(F.funs{i});
end
