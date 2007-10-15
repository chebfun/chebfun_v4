function F = imag(f)
% IMAG	Complex imaginary part
% IMAG(F) is the imaginary part of F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = imag(F.funs{i});
end