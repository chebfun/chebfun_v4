function Fout = erfinv(F)
% ERFINV   Inverse error function for a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = comp(F, @(x) erfinv(x));