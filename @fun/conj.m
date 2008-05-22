function gout = conj(g)
% CONJ	Complex conjugate
% CONJ(F) is the complex conjugate of F.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

gout = g;
gout.vals = conj(gout.vals);