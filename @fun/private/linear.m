function map = linear(ends)
%LINEARMAP creates a map structure for chebfuns
%   MAP = LINEARMAP(ENDS) returns a structure that defines a linear map. 
%   The structure MAP consists of three function handles and one string.
%   MAP.FOR is a function that maps [-1,1] to ENDS.
%   MAP.INV is the inverse map.
%   MAP.DER is the derivative of the map defined in MAP.FOR
%   MAP.ID is a string that identifies the map.
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2009 by The Chebfun Team.
%   First author: Rodrigo Platte, May 2009.
%   Last commit: $Author$: $Rev$:
%   $Date$:

de = diff(ends); se = sum(ends);
map = struct('for',@(y) 0.5*(de*y+se),'inv',@(x) (2*x-se)/de, ...
             'der',@(y) .5*de + 0*y,'name','linear','par', ends) ;
