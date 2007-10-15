function F = log(f)
% LOG	Natural logarithm
% LOG(F) is the natural logarithm of F.  If F passes through 0 LOG(F) will
% fail.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = log(F.funs{i});
end