function out = subsref(varargin)
% Fun SUBSREF just call the built-in SUBSREF.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

out = builtin('subsref',varargin{:});
