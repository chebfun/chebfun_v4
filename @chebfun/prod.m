function Fout = prod(F)
% PROD   Product integral.
% PROD(F) for chebfun F returns exp( sum(log(F)) ).
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = exp(sum(log(F)));