function out = std(f)
% STD	Standard deviation
% STD(F) is the standard deviation of the chebfun F.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
out = sqrt(var(f));

