function gout = uminus(g)
% -	Unary minus
% -G negates the fun G.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

gout = g; gout.vals = -g.vals;