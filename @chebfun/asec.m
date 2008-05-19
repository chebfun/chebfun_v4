function Fout = asec(F)
% ASEC   Inverse secant of a chebfun.
%

% Copyright 2002-2008 by The Chebfun Team. See www.chebfun.org.

Fout = comp(F, @(x) asec(x));
