function Fout = acsc(F)
% ACSC   Inverse cosecant of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) acsc(x));
