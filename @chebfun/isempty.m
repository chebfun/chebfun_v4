function isemp = isempty(F)
% ISEMPTY	True for empty chebfun
% ISEMPTY(F) returns one if F is an empty chebfun and zero otherwise.

% Chebfun Version 2.0


isemp = true;

for k = 1:numel(F)
    isemp = true && isempty(F(k).funs);
end