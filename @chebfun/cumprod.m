function F = cumprod(F)
% CUMPROD   Indefinite product integral.
% CUMPROD(F) is the indefinite product integral of the chebfun F, which 
% is defined as exp( cumsum(log(F)) ).
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

F = exp(cumsum(log(F)));
