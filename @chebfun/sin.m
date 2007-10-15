function F = sin(f)
% SIN   Sine.
% SIN(F) is the sine of F. Effect of impulses is ignored.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
disp('Nick was here!')
for i = 1:nfuns
    F.funs{i} = sin(F.funs{i});
end
