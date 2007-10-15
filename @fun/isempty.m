function out = isempty(f)
% ISEMPTY	True for empty fun
% ISEMPTY(F) returns one if F is an empty fun and zero otherwise.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
out = isempty(f.val);
