function F = cumprod(F)
% CUMPROD   Indefinite product integral.
% CUMPROD(F) is the indefinite product integral of the chebfun F, which 
% is defined as exp( cumsum(log(F)) ).

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

F = exp(cumsum(log(F)));
