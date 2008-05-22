function Fout = prod(F)
% PROD   Product integral.
% PROD(F) for chebfun F returns exp( sum(log(F)) ).

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

Fout = exp(sum(log(F)));