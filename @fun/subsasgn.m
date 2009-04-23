function out = subsasgn(varargin)
% Fun SUBSASGN just call the built-in SUBSASGN.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

out = builtin('subsasgn',varargin{:});
