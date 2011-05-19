function [gout ish] = compfun(g1,op,g2,pref)
% GOUT = COMPFUN(G1,OP,G2)
% Fun composition: GOUT = OP(G1) or GOUT = OG(G1,G2)
% Here GOUT, G1, and G2 are funs, and OP is a function handle.
% This function is called at the chebfun level (CHEBFUN/PRIVATE/COMP.M)
% See also FUN/PRIVATE/GROWFUN.M

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if nargin > 2 && isstruct(g2)
    pref = g2;
    g2 = [];
elseif nargin < 4
    pref = chebfunpref;
end

if nargin > 2 && ~isempty(g2)
    if ~samemap(g1,g2) || any(g1.exps) || any(g2.exps)
        ends = g1.map.par(1:2);
        if norm(ends-g2.map.par(1:2),inf) > 1e-15*max(g1.scl.h,g2.scl.h)
            error('FUN:minus:domain','Domains dont match')
        else
            scl.h = max(g1.scl.h,g2.scl.h);
            scl.v = max(g1.scl.v,g2.scl.v);
            [gout ish] = fun(@(x) op(feval(g1,x),feval(g2,x)), ...
                ends, pref, scl);
        end
    else
        [gout ish] = growfun(op,g1,pref,g1,g2);
    end
else
    if any(g1.exps) % Deal with blowup (exponents)
        scl = g1.scl;
        scl.v = op(scl.v);
        [gout ish] = fun(@(x) op(feval(g1,x)), g1.map.par([1,2]), pref, scl);
    else
        [gout ish] = growfun(op,g1,pref,g1);
    end
end

if ~ish && nargout < 2
    warning('CHEBFUN:fun:compfun:compconv',...
        ['Composition of chebfun with ', func2str(op), ...
         ' failed to converge with ', int2str(gout.n), ' points.']);
end


