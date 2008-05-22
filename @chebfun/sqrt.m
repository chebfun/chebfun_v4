function Fout = sqrt(F)
% SQRT   Square root.
% SQRT(F) returns the square root chebfun of a positive or negative chebfun F. 

%  Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

Fout = comp(F, @(x) sqrt(x));