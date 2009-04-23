function h = ldivide(f,g)
% .\	Pointwise chebfun left divide.
% F.\G returns a chebfun that represents the function G(x)/F(x). 
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

h = rdivide(g,f);