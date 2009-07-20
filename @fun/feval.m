function out = feval(g,x)
% Y = FEVAL(G,X)
% Evaluation of a fun G at points X. In the general case, this is done 
% using the barycentric formula in bary.m. However, if X is a vector of Chebyshev 
% nodes of length 2^n+1 then the evaluation could be done using FFTs through
% prolong.m (faster).
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

if isfield(g.map,'inv')
    out = bary(g.map.inv(x),g.vals);
else
    n = g.n;
    xk = chebpts(n);
    w =  [1/2; ones(n-2,1); 1/2].*(-1).^((0:n-1)'); 
    out = bary(x,g.vals,g.map.for(xk),w);
end