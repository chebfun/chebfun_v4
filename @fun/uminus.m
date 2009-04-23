function gout = uminus(g)
% -	Unary minus
% -G negates the fun G.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

gout = g; gout.vals = -g.vals;