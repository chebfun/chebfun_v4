function H = minus(F1,F2)
% -	  Minus.
% F-G subtracts chebfun G from F, or a scalar from a chebfun if either
% F or G is a scalar.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

H = F1+(-F2);