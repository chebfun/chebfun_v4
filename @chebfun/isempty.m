function out = isempty(F)
% ISEMPTY	True for empty chebfun
% ISEMPTY(F) returns one if F is an empty chebfun and zero otherwise.

% Chebfun Version 2.0

isemp = boolean(numel(F));
for k = 1:numel(F)
    isemp(k) = isempty(F(k).funs);
end
out = all(isemp);
