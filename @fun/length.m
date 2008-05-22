function len = length(g)
% LENGTH	Length of a fun
% LENGTH(F) is the number of Chebyshev points N. 

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

len=0;
if numel(g)>1, error('numel(g)>1'), end
if ~isempty(g), len=g.n; end