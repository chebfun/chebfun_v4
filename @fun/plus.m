function gout = plus(g1,g2)
% +	Plus
% G1 + G2 adds funs G1 and G2 or a scalar to a fun if either G1 or G2 is a
% scalar.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

gout = minus(g1,-g2);