function Fout = asinh(F)
% ASINH   Inverse hyperbolic sine of a chebfun.

% Copyright 2002-2008 by The Chebfun Team. See www.chebfun.org.

Fout = comp(F, @(x) asinh(x));
