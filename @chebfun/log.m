function Fout = log(F)
% LOG   Natural logarithm of a chebfun.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

Fout = comp(F, @(x) log(x));