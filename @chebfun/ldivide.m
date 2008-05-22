function h = ldivide(f,g)
% .\	Pointwise chebfun left divide.
% F.\G returns a chebfun that represents the function G(x)/F(x). 

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

h = rdivide(g,f);