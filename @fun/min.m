function [out,i] = min(f)
% MIN	Global minimum on [-1,1]
% MIN(F) is the global minimum of the fun F on [-1,1].
% [Y,X] = MIN(F) returns the value X such that Y = F(X), Y the global minimum.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

[out,i] = max(-f);
out=-out;