function len = length(g)
% LENGTH	Length of a fun
% LENGTH(F) is the number of Chebyshev points N. 
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

len=0;
if numel(g)>1, error('numel(g)>1'), end
if ~isempty(g), len=g.n; end