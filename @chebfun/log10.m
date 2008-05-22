function Fout = log10(F)
% LOG10   Base 10 logarithm of a chebfun.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

Fout = comp(F, @(x) log10(x));