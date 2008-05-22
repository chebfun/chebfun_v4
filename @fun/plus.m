function gout = plus(g1,g2)
% +	Plus
% G1 + G2 adds funs G1 and G2 or a scalar to a fun if either G1 or G2 is a
% scalar.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

gout = minus(g1,-g2);