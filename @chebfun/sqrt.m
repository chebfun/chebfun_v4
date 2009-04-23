function Fout = sqrt(F)
% SQRT   Square root.
% SQRT(F) returns the square root chebfun of a positive or negative chebfun F. 
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) sqrt(x));