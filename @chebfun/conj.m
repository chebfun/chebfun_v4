function out = conj(f)
% CONJ	Complex conjugate.
% CONJ(F) is the complex conjugate of F.
 
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
out = f;
nfuns = length(f.funs);
for i = 1:nfuns
    out.funs{i} = conj(out.funs{i});
end
