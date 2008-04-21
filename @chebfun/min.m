function [out,pos] = min(f,g)
% MIN   Minimum value of a chebfun.
% MIN(F) returns the minimum value of the chebfun F. 
% 
% H = MIN(F,G), where F and G are chebfuns defined on the same domain,
% returns a chebfun H such that H(x) = min(F(x),G(x)) and x is in the
% domain of F and G.

% Chebfun Version 2.0

if nargin == 1
    [out,pos] = max(-f);
    out = -out;
else
    out = -max(-f,-g);
    pos = [];
end
