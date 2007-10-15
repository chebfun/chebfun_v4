function [out,pos] = max(f,g)
% MAX   Maximum value of a chebfun.
% MAX(F) returns the maximum value of the chebfun F. 
% 
% H = MAX(F,G), where F and G are chebfuns defined on the same domain,
% returns a chebfun H such that H(x) = max(F(x),G(x)) and x is in the
% domain of F and G.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if nargin == 1
    nfuns = length(f.funs);
    ends = f.ends;
    out = zeros(1,nfuns); pos = out;
    for i = 1:nfuns
        a = ends(i); b = ends(i+1);
        [o,p] = max(f.funs{i});
        out(i) = o;
        pos(i) = scale(p,a,b);
    end
    [out I] = max(out);
    pos = pos(I);
else
    Fs = sign(f-g);
    out = ((Fs+1)/2).*f + ((1-Fs)/2).*g ;
    pos = [];
end
% Note: If there is an impulse, return inf (or -inf)