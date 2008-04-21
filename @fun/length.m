function len = length(g)
% LENGTH	Length of a fun
% LENGTH(F) is the number of Chebyshev points N. 

% Chebfun Version 2.0

len=0;
if numel(g)>1, error('numel(g)>1'), end
if ~isempty(g), len=g.n; end