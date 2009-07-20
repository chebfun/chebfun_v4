function out = subsasgn(varargin)
% Fun SUBSASGN just call the built-in SUBSASGN.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author: rodp $: $Rev: 537 $:
% $Date: 2009-07-17 16:15:29 +0100 (Fri, 17 Jul 2009) $:

out = builtin('subsasgn',varargin{:});
