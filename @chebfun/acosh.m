function Fout = acosh(F)
% ACOSH   Inverse hyperbolic cosine of a chebfun.
%

% Copyright 2002-2008 by The Chebfun Team. See www.chebfun.org.

Fout = comp(F, @(x) acosh(x));
