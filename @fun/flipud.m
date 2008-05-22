function f = flipud(f)
% FLIPUD Flip/reverse a fun.
%
% G = FLIPUD(F) returns a fun G such that G(x)=F(-x) for all x.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

f.vals = flipud(f.vals);
