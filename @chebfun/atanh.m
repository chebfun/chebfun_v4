function F = atanh(f)
% ATANH	Inverse hyperbolic tangent.
% ATANH(F) is the inverse hyperbolic tangent of F. Effect of impulses is 
% ignored.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = atanh(F.funs{i});
end