function h = rem(x,y)
% Remainder after division of two chebfuns.
%  REM(X,Y) is X - n.*Y where n = fix(X./Y)
%
% See also rem.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

n = fix(x./y);
h = x-n.*y;
