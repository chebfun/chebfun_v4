function h = mod(x,y)
% Modulus after division of two chebfuns.
%  MOD(X,Y) is X - n.*Y where n = floor(X./Y)
%
% See also mod.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

n = floor(x./y);
h = x-n.*y;
