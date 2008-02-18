function F = tanh(f)
% TANH  Hyperbolic tangent.
% TANH(F) is the hyperbolic tangent of F. Effect of impulses is ignored.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = tanh(F.funs{i});
end
