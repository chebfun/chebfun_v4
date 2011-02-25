function out = subsref(varargin)
% Fun SUBSREF just call the built-in SUBSREF.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

out = builtin('subsref',varargin{:});
