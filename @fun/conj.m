function gout = conj(g)
% CONJ	Complex conjugate
% CONJ(F) is the complex conjugate of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

gout = g;
gout.vals = conj(gout.vals);