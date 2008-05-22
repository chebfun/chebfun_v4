function [out,pos] = min(f,g)
% MIN   Minimum value or pointwise min function.
% MIN(F) returns the minimum value of the chebfun F. 
% 
% H = MIN(F,G), where F and G are chebfuns defined on the same domain,
% returns a chebfun H such that H(x) = min(F(x),G(x)) for all x in the
% domain of F and G.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if nargin == 1
    [out,pos] = max(-f);
    out = -out;
else
    out = -max(-f,-g);
    pos = [];
end
