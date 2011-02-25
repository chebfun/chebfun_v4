function out = int(varargin)
%INT Definite integral of chebfun
% This is simply a dummy routine providining an alternative (more
% intuitive) interface to chebfun/sum.
%
% See also chebfun/sum

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

out = sum(varargin{:});
