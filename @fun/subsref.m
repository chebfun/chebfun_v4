function out = subsref(varargin)
% Fun SUBSREF just call the built-in SUBSREF.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

out = builtin('subsref',varargin{:});
