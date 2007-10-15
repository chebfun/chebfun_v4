function out = isempty(f)
% ISEMPTY	True for empty chebfun
% ISEMPTY(F) returns one if F is an empty chebfun and zero otherwise.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
out = isempty(f.funs);