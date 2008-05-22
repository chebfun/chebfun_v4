function out = feval(g,x)
% Y = FEVAL(G,X)
% Evaluation of a fun G at points X. In the general case, this is done 
% using the barycentric formula in bary.m. However, if X is a vector of Chebyshev 
% nodes of length 2^n+1 then the evaluation could be done using FFTs through
% prolong.m (faster).

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

out = bary(x,g.vals);