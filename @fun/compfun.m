function gout = compfun(g1,op,g2)
% GOUT = COMPFUN(G1,OP,G2)
% Fun composition: GOUT = OP(G1) or GOUT = OG(G1,G2)
% Here GOUT, G1, and G2 are funs, and OP is a function handle.
% This function is called at the chebfun level (CHEBFUN/PRIVATE/COMP.M)
% See also FUN/PRIVATE/GROWFUN.M

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if chebfunpref('splitting')
    n = chebfunpref('splitdegree')+1;
else
    n = chebfunpref('maxdegree')+1;
end

if nargin == 3
    gout = growfun(op,g1,n,g1,g2);
else
    gout = growfun(op,g1,n,g1);
end

