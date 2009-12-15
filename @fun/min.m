function [out,i] = min(g)
% MIN	Global minimum on [-1,1]
% MIN(G) is the global minimum of the fun G on [-1,1].
% [Y,X] = MIN(G) returns the value X such that Y = G(X), Y the global minimum.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

[out,i] = max(-g);
out=-out;