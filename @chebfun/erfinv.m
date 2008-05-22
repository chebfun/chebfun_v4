function Fout = erfinv(F)
% ERFINV   Inverse error function for a chebfun.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

Fout = comp(F, @(x) erfinv(x));