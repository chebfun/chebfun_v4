function f = flipud(f)
% FLIPUD Flip/reverse a fun.
%
% G = FLIPUD(F) returns a fun G such that G(x)=F(-x) for all x.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

f.vals = flipud(f.vals);
