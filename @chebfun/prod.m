function Fout = prod(F)
% PROD   Product integral.
% PROD(F) for chebfun F returns exp( sum(log(F)) ).
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = exp(sum(log(F)));