function F = abs(f)
% ABS   Absolute value of a chebfun.
% ABS(f) is the absolute value of the real-valued chebfun f.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = sign(f).*f;